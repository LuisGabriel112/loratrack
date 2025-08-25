from django.db import models

estado_choices = [
    ('activo', 'Activo'),
    ('inactivo', 'Inactivo'),
]
# Create your models here.
class nodo (models.Model):
    id = models.AutoField(primary_key=True)
    nombre = models.CharField(max_length=100)
    fecha_creacion = models.DateTimeField(auto_now_add=True)
    fecha_actualizacion = models.DateTimeField(auto_now=True)
    estado = models.CharField(max_length=10, choices=estado_choices, default='activo')

    def __str__(self):
        return self.nombre

class usuario (models.Model):
    id = models.AutoField(primary_key=True)
    usuario = models.CharField(max_length=100)
    contrasena = models.CharField(max_length=100)
    fecha_creacion = models.DateTimeField(auto_now_add=True)
    fecha_actualizacion = models.DateTimeField(auto_now=True)

    def __str__(self):
        return self.usuario

class dispositivos (models.Model):
    id = models.AutoField(primary_key=True)
    nombre = models.CharField(max_length=100)
    marca = models.CharField(max_length=100)
    descripcion = models.TextField()
    fecha_creacion = models.DateTimeField(auto_now_add=True)
    fecha_actualizacion = models.DateTimeField(auto_now=True)

    def __str__(self):
        return self.nombre