from django.db import models
from datetime import timedelta

estado_choices = [
    ('activo', 'Activo'),
    ('inactivo', 'Inactivo'),
]
# Create your models here.
class nodo (models.Model):
    id = models.AutoField(primary_key=True)
    imei = models.CharField(max_length=15, default='IM-0')
    nombre = models.CharField(max_length=100)
    latitud = models.FloatField(null=True, blank=True)
    longitud = models.FloatField(null=True, blank=True)
    ultima_vez_visto = models.DateTimeField(null=True, blank=True)
    fecha_creacion = models.DateTimeField(auto_now_add=True)
    fecha_actualizacion = models.DateTimeField(auto_now=True)
    estado = models.CharField(max_length=10, choices=estado_choices, default='activo')

    def __str__(self):
        return self.nombre


class dispositivos (models.Model):
    id = models.AutoField(primary_key=True)
    nombre = models.CharField(max_length=100)
    marca = models.CharField(max_length=100)
    descripcion = models.TextField()
    imagen = models.ImageField(upload_to='dispositivos_img/', null=True, blank=True)
    fecha_creacion = models.DateTimeField(auto_now_add=True)
    fecha_actualizacion = models.DateTimeField(auto_now=True)

    def __str__(self):
        return self.nombre