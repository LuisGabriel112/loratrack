from django.urls import path
from . import views

urlpatterns = [
    path('login/', views.inicio, name='login'),
    path('', views.mapa_tiempo_real, name='mapa_tiempo_real'),
    path('dispositivos/', views.vista_dispositivos, name='dispositivos'),
    path('nodos/', views.nodos, name='nodos'),
    path('logout/', views.logout_view, name='logout'),
    path('aside_bar/', views.aside_bar, name='aside_bar'),
    path('base/', views.base, name='base'),
    path('prueba/', views.prueba, name='prueba'),
]
