# arac_alim_backend/api/permissions.py

from rest_framework import permissions

class IsOwnerOrReadOnly(permissions.BasePermission):
    """
    Objeyi oluşturan (owner) kullanıcı değilse,
    sadece SAFE_METHODS (GET, HEAD, OPTIONS) izni ver.
    SAFE_METHODS dışındakiler (PUT/PATCH/DELETE) için obj.owner == request.user olmalı.
    """

    def has_object_permission(self, request, view, obj):
        # Her zaman okuma (GET, HEAD, OPTIONS) isteklerine izin ver.
        if request.method in permissions.SAFE_METHODS:
            return True
        # Diğer (PUT, PATCH, DELETE) isteklerinde ancak obj.owner == request.user ise izin ver.
        return obj.owner == request.user
