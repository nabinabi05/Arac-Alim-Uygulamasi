# Generated by Django 5.2.1 on 2025-06-03 07:36

import django.db.models.deletion
from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('api', '0004_remove_activity_description_remove_activity_title_and_more'),
    ]

    operations = [
        migrations.AlterField(
            model_name='activity',
            name='car',
            field=models.ForeignKey(blank=True, null=True, on_delete=django.db.models.deletion.CASCADE, related_name='activities', to='api.car'),
        ),
    ]
