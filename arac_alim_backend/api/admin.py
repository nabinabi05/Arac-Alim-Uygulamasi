# lib_alim_backend/api/admin.py

from django.contrib import admin
from .models import Car, Activity

admin.site.register(Car)
admin.site.register(Activity)
