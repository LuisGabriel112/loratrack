"""
ASGI config for loratrack project.

It exposes the ASGI callable as a module-level variable named ``application``.

For more information on this file, see
https://docs.djangoproject.com/en/5.2/howto/deployment/asgi/
"""
import os
from django.core.asgi import get_asgi_application

# Establece la variable de entorno para los settings de Django.
# Esto debe hacerse antes de importar cualquier otro componente de Django.
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'loratrack.settings')

# Inicializa la aplicación ASGI de Django para asegurar que el framework
# se cargue y los modelos estén listos antes de importar los consumidores.
django_asgi_app = get_asgi_application()

from channels.routing import ProtocolTypeRouter, URLRouter
from channels.auth import AuthMiddlewareStack
from django.urls import path
from lorafi.consumers import MyConsumer

websocket_urlpatterns = [
    path('ws/chat/', MyConsumer.as_asgi()),
]

application = ProtocolTypeRouter({
    "http": django_asgi_app,
    "websocket": AuthMiddlewareStack(
        URLRouter(
            websocket_urlpatterns
        )
    ),
})
