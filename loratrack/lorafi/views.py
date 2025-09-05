# Primero, importo todo lo que necesito de Django y otras librerías.
from django.shortcuts import render, redirect
from django.contrib.auth import authenticate, login # Para manejar la autenticación de usuarios.
from django.contrib import messages # Para mostrar mensajes flash al usuario.
from .models import * # Importo todos mis modelos de la app.
import folium # La estrella del show para los mapas.
from django.contrib.auth import logout # Para cerrar sesión del usuario.
from django.core.paginator import Paginator # Para la paginación.

# Esta vista es para mostrar la lista de todos mis dispositivos.
def vista_dispositivos(request):
    # Hago una consulta a la base de datos para traerme todos los dispositivos.
    # El .objects.all() es el comando de Django para obtener todo de un modelo.
    todos_los_dispositivos = dispositivos.objects.all()

    # Preparo el 'contexto', que es un diccionario que le paso a mi plantilla.
    # Así, en el HTML, puedo usar la variable 'dispositivos' para mostrar la lista.
    contexto = {
        'dispositivos': todos_los_dispositivos
    }

    # Renderizo la plantilla 'dispositivos.html' y le paso el contexto.
    return render(request, 'dispositivos.html', contexto)



# Esta es la vista para mi página de inicio de sesión.
def inicio(request):
    # Si el usuario está enviando el formulario (método POST)...
    if request.method == 'POST':
        # Obtengo el usuario y la contraseña que escribieron en el formulario.
        usuario = request.POST.get('usuario')
        contrasena = request.POST.get('contrasena')
        # Intento autenticar al usuario con las credenciales que me dieron.
        user = authenticate(request, username=usuario, password=contrasena)
        # Si la autenticación fue exitosa...
        if user is not None:
            # Inicio la sesión para este usuario.
            login(request, user)
            # Y lo redirijo a la pantalla principal de la aplicación.
            return redirect('pantalla_principal')
        else:
            # Si las credenciales no son válidas, le muestro un mensaje de error.
            messages.error(request, 'Usuario o contraseña incorrectos.')
    # Si no es una petición POST (o si falló el login), simplemente muestro la página de inicio.
    return render(request, 'index.html')

# Vista para cerrar la sesión del usuario.
def logout_view(request):
    # La función logout de Django se encarga de limpiar la sesión.
    logout(request)
    # Redirijo al usuario a la página de inicio de sesión.
    return redirect('inicio')

# La vista principal de mi aplicación, donde muestro el mapa.
def pantalla_principal(request):
    # --- Para este ejemplo, estoy usando datos fijos ---
    # En el futuro, la idea es tomar estas coordenadas de la base de datos.
    # Por ahora, uso puntos en Veracruz para visualizar el mapa.
    dispositivos_ejemplo = [
        {'nombre': 'Dispositivo 1 (Veracruz)', 'lat': 19.1738, 'lon': -96.1342},
        {'nombre': 'Dispositivo 2 (Veracruz)', 'lat': 19.1750, 'lon': -96.1350},
        {'nombre': 'Dispositivo 3 (Veracruz)', 'lat': 19.1700, 'lon': -96.1300},
    ]

    # Creo el objeto de mapa con Folium, centrado en el primer dispositivo.
    # Añado la atribución requerida para la capa base 'cartodbdark_matter'.
    mapa = folium.Map(
        location=[dispositivos_ejemplo[0]['lat'], dispositivos_ejemplo[0]['lon']],
        zoom_start=15,
        tiles='cartodbdark_matter',
        attr='&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors &copy; <a href="https://carto.com/attributions">CARTO</a>'
    )

    # --- Añadiendo capas de mapas para el selector con su atribución ---
    folium.TileLayer(
        'OpenStreetMap',
        name='Estándar',
        attr='&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
    ).add_to(mapa)

    folium.TileLayer(
        tiles='https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}',
        attr='Esri',
        name='Satélite'
    ).add_to(mapa)

    # Capa clara de CartoDB (Positron)
    folium.TileLayer(
        'cartodbpositron',
        name='Claro',
        attr='&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors &copy; <a href="https://carto.com/attributions">CARTO</a>'
    ).add_to(mapa)

    # Recorro mi lista de dispositivos de ejemplo para poner un marcador para cada uno.
    for disp in dispositivos_ejemplo:
        folium.Marker(
            location=[disp['lat'], disp['lon']], # Coordenadas del marcador.
            popup=f"<i>{disp['nombre']}</i>",  # Lo que se ve al hacer clic en el marcador.
            tooltip='Haz clic para ver más'  # El mensajito que aparece al pasar el mouse por encima.
        ).add_to(mapa) # Añado el marcador al mapa que creé antes.

    # --- Añado el control de capas al mapa ---
    folium.LayerControl().add_to(mapa)

    # Folium necesita que convierta el mapa a código HTML para poder mostrarlo en mi plantilla.
    mapa_html = mapa._repr_html_()

    # Consulto todos los dispositivos para pasarlos a la plantilla.
    todos_los_dispositivos = dispositivos.objects.all()

    # De nuevo, preparo el contexto para la plantilla.
    contexto = {
        'mapa_html': mapa_html,
        'dispositivos': todos_los_dispositivos
    }
    # Renderizo la plantilla de la pantalla principal y le paso el mapa y los dispositivos en el contexto.
    return render(request, 'pantalla_principal.html', contexto)

# Vista para mostrar la página de nodos.
def nodos(request):
    # Aquí consulto todos los objetos del modelo 'nodo'.
    lista_nodos = nodo.objects.all()
    # Creo un paginador para la lista de nodos, mostrando 5 nodos por página.
    paginador = Paginator(lista_nodos, 5)

    # Obtengo el número de página de la URL (si no existe, por defecto es 1).
    numero_pagina = request.GET.get('page', 1)
    # Obtengo la página actual del paginador.
    pagina_actual = paginador.get_page(numero_pagina)

    # Preparo el contexto para pasárselo a la plantilla.
    # Ahora, en lugar de pasar todos los nodos, paso la página actual.
    contexto = {
        'nodos': pagina_actual
    }

    # Renderizo la plantilla 'nodos.html' con la página de nodos.
    return render(request, 'nodos.html', contexto)

def aside_bar(request):
    return render(request, 'aside_bar.html')

def base(request):
    return render(request, 'base.html')