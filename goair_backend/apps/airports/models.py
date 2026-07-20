from django.db import models


class Airport(models.Model):
    code = models.CharField(max_length=5, unique=True, db_index=True)  # IATA or internal
    name = models.CharField(max_length=140)
    city = models.CharField(max_length=120)
    country = models.CharField(max_length=120)

    latitude = models.DecimalField(max_digits=9, decimal_places=6, null=True, blank=True)
    longitude = models.DecimalField(max_digits=9, decimal_places=6, null=True, blank=True)

    timezone = models.CharField(max_length=64, default='UTC')

    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        indexes = [
            models.Index(fields=['code']),
        ]
        ordering = ['name']

    def __str__(self):
        return f'{self.code} - {self.name}'

