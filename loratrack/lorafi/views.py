from django.shortcuts import render
from .models import *

def inicio(request):
    return render(request, 'index.html')


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
