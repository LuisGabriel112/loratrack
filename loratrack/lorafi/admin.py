from django.contrib import admin
from .models import dispositivos
from .models import nodo
# Register your models here.
admin.site.register(dispositivos)
admin.site.register(nodo)