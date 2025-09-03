from django.urls import path
from . import views

urlpatterns = [
    path('', views.inicio, name='inicio'),
    path('dispositivos/', views.vista_dispositivos, name='dispositivos'),
    path('pantalla_principal/', views.pantalla_principal, name='pantalla_principal'),
    path('nodos/', views.nodos, name='nodos'),
    path('logout/', views.logout_view, name='logout'),
    path('aside_bar/', views.aside_bar, name='aside_bar'),
    path('base/', views.base, name='base'),
]
