import json
import asyncio
import random
from channels.generic.websocket import AsyncWebsocketConsumer
from channels.db import database_sync_to_async
from .models import nodo
from datetime import datetime

class MyConsumer(AsyncWebsocketConsumer):
    # Tarea en segundo plano para esta conexión específica
    update_task = None

    async def connect(self):
        # Aceptar la conexión WebSocket
        await self.accept()

        # Iniciar la tarea de actualización de coordenadas
        self.update_task = asyncio.create_task(self.send_location_updates())

    async def disconnect(self, close_code):
        # Cancelar la tarea de actualización cuando el cliente se desconecta
        if self.update_task:
            self.update_task.cancel()

    async def receive(self, text_data):
        text_data_json = json.loads(text_data)
        message = text_data_json['message']

        await self.send(text_data=json.dumps({
            'message': message
        }))

    async def send_location_updates(self):
        # Coordenadas base para la ubicación de Veracruz
        lat_base = 19.1738
        lon_base = -96.1342
        # Define un rango pequeño para la variación
        rango_variacion = 0.005

        try:
            while True:
                try:
                    # Obtener todos los nodos de la base de datos
                    nodos = await self.get_nodos()
                    nodos_data = []

                    # Si no hay nodos en la base de datos, crear datos de ejemplo
                    if not nodos:
                        for i in range(1, 11):
                            # Calcula una variación aleatoria para latitud y longitud
                            lat_variacion = random.uniform(-rango_variacion, rango_variacion)
                            lon_variacion = random.uniform(-rango_variacion, rango_variacion)

                            nodos_data.append({
                                'id': i,
                                'nombre': f'Dispositivo {i} (Veracruz)',
                                'lat': round(lat_base + lat_variacion, 6),
                                'lon': round(lon_base + lon_variacion, 6)
                            })
                    else:
                        # Actualizar las coordenadas de los nodos existentes
                        for nodo_obj in nodos:
                            # Calcular nuevas coordenadas con variaciones aleatorias alrededor de la base
                            lat_variacion = random.uniform(-rango_variacion, rango_variacion)
                            lon_variacion = random.uniform(-rango_variacion, rango_variacion)

                            # Siempre calculamos desde el punto base para mantener los nodos dentro del área de Veracruz.
                            nueva_lat = round(lat_base + lat_variacion, 6)
                            nueva_lon = round(lon_base + lon_variacion, 6)

                            # Actualizar el nodo en la base de datos (asíncrono)
                            # Volvemos a la actualización individual, ya que djongo no soporta bulk_update.
                            await self.update_nodo_location(nodo_obj, nueva_lat, nueva_lon)

                            nodos_data.append({
                                'id': nodo_obj.id,
                                'nombre': nodo_obj.nombre,
                                'lat': nueva_lat,
                                'lon': nueva_lon
                            })

                    # Enviar las actualizaciones de ubicación a través del WebSocket
                    await self.send(text_data=json.dumps({
                        'type': 'location_update',
                        'nodos': nodos_data
                    }))

                except Exception as e:
                    # Imprimir el error en la consola del servidor para depuración
                    print(f"ERROR en el bucle de actualización del WebSocket: {e}")
                    import traceback
                    traceback.print_exc()
                    # Romper el bucle en caso de error para cerrar la conexión de forma limpia
                    break

                # Esperar 3 segundos antes de la próxima actualización
                await asyncio.sleep(1)
        except asyncio.CancelledError:
            # Manejar la cancelación de la tarea
            # Esto es normal cuando un cliente se desconecta.
            print("Tarea de actualización de ubicación cancelada.")

    @database_sync_to_async
    def get_nodos(self):
        # Obtiene todos los nodos de la base de datos de forma asíncrona segura.
        return list(nodo.objects.all())

    @database_sync_to_async
    def update_nodo_location(self, nodo_obj, lat, lon):
        # Actualiza la ubicación y la última vez visto de un nodo.
        # Es más eficiente pasar el objeto si ya lo tenemos para evitar una consulta extra.
        nodo_obj.latitud = lat
        nodo_obj.longitud = lon
        nodo_obj.ultima_vez_visto = datetime.now()
        nodo_obj.save(update_fields=['latitud', 'longitud', 'ultima_vez_visto'])