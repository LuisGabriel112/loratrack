from django.urls import path
from . import views

urlpatterns = [
    path('', views.inicio, name='inicio'),
    path('dispositivos/', views.vista_dispositivos, name='dispositivos'),
]
