from django.contrib import admin
from .models import nodo, usuario, dispositivos;
# Register your models here.
admin.site.register(nodo)
admin.site.register(usuario)
admin.site.register(dispositivos)