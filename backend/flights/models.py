import uuid

from django.db import models


class Airport(models.Model):
    code = models.CharField(max_length=10, unique=True, db_index=True)
    name = models.CharField(max_length=255)
    city = models.CharField(max_length=255)
    country = models.CharField(max_length=255)
    terminal_count = models.PositiveIntegerField(default=1)
    lat = models.FloatField()
    lng = models.FloatField()
    timezone = models.CharField(max_length=50)

    class Meta:
        ordering = ('code',)

    def __str__(self):
        return f'{self.code} - {self.city}, {self.country}'


class Airline(models.Model):
    ALLIANCE_CHOICES = (
        ('star_alliance', 'Star Alliance'),
        ('one_world', 'oneworld'),
        ('sky_team', 'SkyTeam'),
        ('none', 'None'),
    )

    code = models.CharField(max_length=10, unique=True, db_index=True)
    name = models.CharField(max_length=255)
    logo_url = models.URLField(blank=True, default='')
    alliance = models.CharField(max_length=20, choices=ALLIANCE_CHOICES, default='none')

    class Meta:
        ordering = ('name',)

    def __str__(self):
        return f'{self.code} - {self.name}'


class Flight(models.Model):
    STATUS_CHOICES = (
        ('scheduled', 'Scheduled'),
        ('boarding', 'Boarding'),
        ('departed', 'Departed'),
        ('arrived', 'Arrived'),
        ('delayed', 'Delayed'),
        ('cancelled', 'Cancelled'),
    )

    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    flight_number = models.CharField(max_length=20, db_index=True)
    airline = models.ForeignKey(Airline, on_delete=models.CASCADE, related_name='flights')
    departure_airport = models.ForeignKey(Airport, on_delete=models.CASCADE, related_name='departures')
    arrival_airport = models.ForeignKey(Airport, on_delete=models.CASCADE, related_name='arrivals')
    departure_time = models.DateTimeField()
    arrival_time = models.DateTimeField()
    terminal = models.CharField(max_length=10, blank=True, default='')
    gate = models.CharField(max_length=10, blank=True, default='')
    status = models.CharField(max_length=20, choices=STATUS_CHOICES, default='scheduled')
    aircraft = models.CharField(max_length=100, blank=True, default='')
    delay_minutes = models.PositiveIntegerField(null=True, blank=True)
    boarding_group = models.CharField(max_length=20, null=True, blank=True)
    baggage_claim = models.CharField(max_length=20, null=True, blank=True)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        ordering = ('departure_time',)

    def __str__(self):
        return f'{self.airline.code}{self.flight_number}'


class FlightUpdate(models.Model):
    flight = models.ForeignKey(Flight, on_delete=models.CASCADE, related_name='updates')
    old_status = models.CharField(max_length=20, blank=True, default='')
    new_status = models.CharField(max_length=20, blank=True, default='')
    old_gate = models.CharField(max_length=10, blank=True, default='')
    new_gate = models.CharField(max_length=10, blank=True, default='')
    old_time = models.DateTimeField(null=True, blank=True)
    new_time = models.DateTimeField(null=True, blank=True)
    reason = models.TextField(blank=True, default='')
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        ordering = ('-created_at',)

    def __str__(self):
        return f'{self.flight.flight_number} update @ {self.created_at}'
