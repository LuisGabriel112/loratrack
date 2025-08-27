from django.shortcuts import render, redirect
from django.contrib.auth import authenticate, login
from django.contrib import messages
from .models import *
import folium


def vista_dispositivos(request):
    # Obtiene todos los objetos del modelo 'dispositivos'
    todos_los_dispositivos = dispositivos.objects.all()

    # Crea un diccionario con los datos. La clave 'dispositivos'
    # será el nombre de la variable en tu plantilla HTML.
    contexto = {
        'dispositivos': todos_los_dispositivos
    }

    # Pasa el diccionario de contexto a la plantilla
    return render(request, 'dispositivos.html', contexto)



def inicio(request):
    if request.method == 'POST':
        usuario = request.POST.get('usuario')
        contrasena = request.POST.get('contrasena')
        user = authenticate(request, username=usuario, password=contrasena)
        if user is not None:
            login(request, user)
            return redirect('pantalla_principal')
        else:
            messages.error(request, 'Usuario o contraseña incorrectos.')
    return render(request, 'index.html')

def pantalla_principal(request):
    # --- Ejemplo de Mapa con Folium ---

    # 1. Coordenadas de ejemplo (en el futuro, las tomarías de tu base de datos)
    # Usaremos el centro de Veracruz como ejemplo.
    dispositivos_ejemplo = [
        {'nombre': 'Dispositivo 1 (Veracruz)', 'lat': 19.1738, 'lon': -96.1342},
        {'nombre': 'Dispositivo 2 (Veracruz)', 'lat': 19.1750, 'lon': -96.1350},
        {'nombre': 'Dispositivo 3 (Veracruz)', 'lat': 19.1700, 'lon': -96.1300},
    ]

    # 2. Crear el mapa, centrado en la primera coordenada
    # Puedes ajustar el zoom inicial. Un número más alto acerca más el mapa.
    mapa = folium.Map(location=[dispositivos_ejemplo[0]['lat'], dispositivos_ejemplo[0]['lon']], zoom_start=13)

    # 3. Añadir un marcador por cada dispositivo de ejemplo
    for disp in dispositivos_ejemplo:
        folium.Marker(
            location=[disp['lat'], disp['lon']],
            popup=f"<i>{disp['nombre']}</i>",  # El texto que aparece al hacer clic
            tooltip='Haz clic para ver más'  # El texto que aparece al pasar el mouse
        ).add_to(mapa)

    # 4. Convertir el mapa a HTML
    mapa_html = mapa._repr_html_()

    contexto = {
        'mapa_html': mapa_html
    }
    return render(request, 'pantalla_principal.html', contexto)

def nodos(request):
     # Obtiene todos los objetos del modelo 'nodos'
    todos_los_nodos = nodo.objects.all()

    # Crea un diccionario con los datos. La clave 'nodos'
    # será el nombre de la variable en tu plantilla HTML.
    contexto = {
        'nodos': todos_los_nodos
    }

    # Pasa el diccionario de contexto a la plantilla
    return render(request, 'nodos.html', contexto)