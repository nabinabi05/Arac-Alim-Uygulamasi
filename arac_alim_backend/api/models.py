from django.db import models
from django.contrib.auth import get_user_model

User = get_user_model()

class Car(models.Model):
    owner = models.ForeignKey(
        User, on_delete=models.CASCADE, related_name='my_cars'
    )
    brand = models.CharField(max_length=100)
    model_name = models.CharField(max_length=100)
    year = models.IntegerField()
    price = models.FloatField()
    description = models.TextField(blank=True)
    latitude = models.DecimalField(
        max_digits=8, decimal_places=6, null=True, blank=True
    )
    longitude = models.DecimalField(
        max_digits=9, decimal_places=6, null=True, blank=True
    )
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f'{self.brand} {self.model_name} ({self.year})'


class Activity(models.Model):
    ACTIVITY_TYPES = [
        ("price_update", "Price updated"),
        ("favorite",    "Marked as favorite"),
        ("new_car",     "New car added"),
    ]

    user = models.ForeignKey(User, on_delete=models.CASCADE, related_name="activities")
    car  = models.ForeignKey(
        Car, on_delete=models.CASCADE, related_name="activities",
        null=True, blank=True
    )
    activity_type = models.CharField(
        max_length=30,
        choices=ACTIVITY_TYPES,
        null=True, blank=True,
    )
    message = models.CharField(max_length=255, default="")
    timestamp = models.DateTimeField(auto_now_add=True)

