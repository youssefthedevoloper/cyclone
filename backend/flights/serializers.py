from rest_framework import serializers

from .models import Airport, Airline, Flight, FlightUpdate


class AirportSerializer(serializers.ModelSerializer):
    class Meta:
        model = Airport
        fields = '__all__'


class AirlineSerializer(serializers.ModelSerializer):
    class Meta:
        model = Airline
        fields = '__all__'


class FlightUpdateSerializer(serializers.ModelSerializer):
    class Meta:
        model = FlightUpdate
        fields = '__all__'
        read_only_fields = ('created_at',)


class FlightSerializer(serializers.ModelSerializer):
    airline = AirlineSerializer(read_only=True)
    airline_id = serializers.UUIDField(write_only=True, required=False)
    departure_airport = AirportSerializer(read_only=True)
    departure_airport_id = serializers.UUIDField(write_only=True, required=False)
    arrival_airport = AirportSerializer(read_only=True)
    arrival_airport_id = serializers.UUIDField(write_only=True, required=False)
    updates = FlightUpdateSerializer(many=True, read_only=True)

    class Meta:
        model = Flight
        fields = '__all__'
        read_only_fields = ('id', 'created_at', 'updated_at')


class FlightListSerializer(serializers.ModelSerializer):
    airline_code = serializers.CharField(source='airline.code', read_only=True)
    airline_name = serializers.CharField(source='airline.name', read_only=True)
    departure_code = serializers.CharField(source='departure_airport.code', read_only=True)
    departure_city = serializers.CharField(source='departure_airport.city', read_only=True)
    arrival_code = serializers.CharField(source='arrival_airport.code', read_only=True)
    arrival_city = serializers.CharField(source='arrival_airport.city', read_only=True)

    class Meta:
        model = Flight
        fields = (
            'id', 'flight_number', 'airline_code', 'airline_name',
            'departure_code', 'departure_city',
            'arrival_code', 'arrival_city',
            'departure_time', 'arrival_time',
            'terminal', 'gate', 'status', 'aircraft',
            'delay_minutes', 'boarding_group', 'baggage_claim',
        )
