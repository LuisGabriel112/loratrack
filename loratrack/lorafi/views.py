# Primero, importo todo lo que necesito de Django y otras librerías.
from django.shortcuts import render, redirect
from django.contrib.auth import authenticate, login # Para manejar la autenticación de usuarios.
from django.contrib import messages # Para mostrar mensajes flash al usuario.
from .models import * # Importo todos mis modelos de la app.
import folium # La estrella del show para los mapas.
from django.contrib.auth import logout # Para cerrar sesión del usuario.
from django.core.paginator import Paginator # Para la paginación.
import random # Para generar números aleatorios.
from django.contrib.auth.decorators import login_required # Para proteger vistas

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
            # Y lo redirijo al mapa en tiempo real, que ahora es la página principal.
            return redirect('mapa_tiempo_real')
        else:
            # Si las credenciales no son válidas, le muestro un mensaje de error.
            messages.error(request, 'Usuario o contraseña incorrectos.')
    # Si no es una petición POST (o si falló el login), simplemente muestro la página de inicio.
    return render(request, 'index.html')

# Vista para cerrar la sesión del usuario.
def logout_view(request):
    # La función logout de Django se encarga de limpiar la sesión.
    logout(request)
    # Redirijo al usuario a la página de inicio de sesión usando el nombre de la URL.
    return redirect('login')

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
    return render(request, 'nodos.html', contexto)

# Vista para mostrar el mapa en tiempo real con WebSockets
# Ahora esta es la página principal y requiere que el usuario haya iniciado sesión.
@login_required
def mapa_tiempo_real(request):
    # Consulto todos los dispositivos para pasarlos a la plantilla
    todos_los_dispositivos = dispositivos.objects.all()

    # Preparo el contexto para la plantilla
    contexto = {
        'dispositivos': todos_los_dispositivos
    }
    # Renderizo la plantilla del mapa en tiempo real
    return render(request, 'mapa_tiempo_real.html', contexto)

def aside_bar(request):
    return render(request, 'aside_bar.html')

def base(request):
    return render(request, 'base.html')

def prueba(request):
    return render(request, 'prueba.html')