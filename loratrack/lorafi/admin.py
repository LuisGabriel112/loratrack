from django.contrib import admin
from .models import dispositivos, nodo

class NodoAdmin(admin.ModelAdmin):
    readonly_fields = ('latitud', 'longitud', 'ultima_vez_visto')

class DispositivosAdmin(admin.ModelAdmin):
    pass

admin.site.register(dispositivos, DispositivosAdmin)
admin.site.register(nodo, NodoAdmin)