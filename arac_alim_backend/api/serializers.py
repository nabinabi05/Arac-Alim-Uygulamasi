# arac_alim_backend/api/serializers.py

from rest_framework import serializers
from .models import Car, Activity
from django.contrib.auth.models import User

class CarSerializer(serializers.ModelSerializer):
    owner = serializers.PrimaryKeyRelatedField(read_only=True)

    class Meta:
        model = Car
        fields = [
            'id',
            'owner',
            'brand',
            'model_name',
            'year',
            'price',
            'description',
            'latitude',
            'longitude',
            'created_at',
        ]
        read_only_fields = ['id', 'owner', 'created_at']


class ActivitySerializer(serializers.ModelSerializer):
    user = serializers.PrimaryKeyRelatedField(read_only=True)

    class Meta:
        model = Activity
        fields = [
            'id',
            'user',
            'car',            # Önemli: `car` burada olmalı
            'activity_type',  # burası da eksik olmamalı
            'message',
            'timestamp',
        ]
        read_only_fields = ['id', 'user', 'timestamp']

class UserSerializer(serializers.ModelSerializer):
    password = serializers.CharField(write_only=True)
    class Meta:
        model = User
        fields = ['id', 'username', 'password']
        read_only_fields = ['id']

    def create(self, validated_data):
        user = User(username=validated_data['username'])
        user.set_password(validated_data['password'])
        user.save()
        return user
