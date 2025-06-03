# arac_alim_backend/api/views.py

from rest_framework import viewsets, permissions, status
from rest_framework.response import Response

from .models import Car, Activity
from .serializers import CarSerializer, ActivitySerializer, UserSerializer
from .permissions import IsOwnerOrReadOnly
from django.contrib.auth.models import User

class CarViewSet(viewsets.ModelViewSet):
    """
    Araba CRUD işlemleri:
      - CREATE: request.user -> owner olarak atanır
      - UPDATE (PUT/PATCH): Sadece sahibi yapabilir; eğer fiyat değiştiyse Activity yaratır
      - DELETE: Sadece sahibi yapabilir
    """
    queryset = Car.objects.all()
    serializer_class = CarSerializer

    # Sadece oturum açmış kullanıcı oluşturabilir; güncelleme/silme için ise IsOwnerOrReadOnly devrede
    permission_classes = [permissions.IsAuthenticated, IsOwnerOrReadOnly]

    def perform_create(self, serializer):
        # Yeni araba eklenince owner = request.user olsun
        car = serializer.save(owner=self.request.user)

        # İsterseniz “new_car” aktivitesi ekleyebilirsiniz. Örnek:
        # Activity.objects.create(
        #     user=self.request.user,
        #     car=car,
        #     activity_type='new_car',
        #     message=f"Yeni araç eklendi: {car.brand} {car.model_name} ({car.year})",
        # )

    def update(self, request, *args, **kwargs):
        """
        PUT veya PATCH tetiklendiğinde, eski fiyat ile yeni fiyatı kontrol edip
        fiyat değiştiyse otomatik Activity nesnesi yaratırız.
        """
        partial = kwargs.pop('partial', False)
        instance: Car = self.get_object()
        old_price = instance.price

        serializer = self.get_serializer(
            instance, data=request.data, partial=partial
        )
        serializer.is_valid(raise_exception=True)
        self.perform_update(serializer)
        new_price = serializer.instance.price

        # Eğer fiyat değişmişse, o an Activity yarat:
        if old_price != new_price:
            Activity.objects.create(
                user=request.user,
                car=instance,   # <-- BURASI EKLENDİ
                activity_type='price_update',
                message=(
                    f"{instance.brand} {instance.model_name} fiyatı ₺"
                    f"{old_price:,.0f} → ₺{new_price:,.0f} olarak güncellendi."
                )
            )

        return Response(serializer.data, status=status.HTTP_200_OK)


class UserViewSet(viewsets.ModelViewSet):
    """
    Kullanıcı hesapları:
      - Yeni kullanıcı oluştur (register)
      - Authenticate edilmiş kullanıcılar listeleyebilir
    """
    queryset = User.objects.all()
    serializer_class = UserSerializer
    permission_classes = [permissions.AllowAny]  # Herkes görebilir, sadece register için IsAuthenticated gerekli

    def perform_create(self, serializer):
        serializer.save()


class ActivityViewSet(viewsets.ModelViewSet):
    """
    Activity CRUD:
      - GET /api/activities/: Herkes görebilir (liste)
      - POST /api/activities/: Sadece authenticate edilmiş kullanıcı ekleyebilir
      - PUT/PATCH/DELETE: Sadece Activity sahibi yapabilir (sonradan eklenecek ek kontrol)
    """
    queryset = Activity.objects.all().order_by('-timestamp')
    serializer_class = ActivitySerializer
    permission_classes = [permissions.IsAuthenticatedOrReadOnly]

    def perform_create(self, serializer):
        serializer.save(user=self.request.user)
