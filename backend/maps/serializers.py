from rest_framework import serializers


class AmenitySerializer(serializers.Serializer):
    id = serializers.CharField()
    name = serializers.CharField()
    type = serializers.CharField()
    terminal = serializers.CharField()
    gate_area = serializers.CharField()
    description = serializers.CharField()
    coordinates = serializers.DictField(child=serializers.FloatField())


class ParkingSerializer(serializers.Serializer):
    id = serializers.CharField()
    name = serializers.CharField()
    terminal = serializers.CharField()
    type = serializers.CharField()
    capacity = serializers.IntegerField()
    rates = serializers.DictField(child=serializers.IntegerField(allow_null=True))
    description = serializers.CharField()


class TerminalSerializer(serializers.Serializer):
    number = serializers.IntegerField()
    name = serializers.CharField()
    description = serializers.CharField()
    coordinates = serializers.DictField(child=serializers.FloatField())


class AirportMapSerializer(serializers.Serializer):
    code = serializers.CharField()
    name = serializers.CharField()
    location = serializers.DictField()
    terminals = TerminalSerializer(many=True)
    gates = serializers.DictField(child=serializers.ListField(child=serializers.CharField()))
    amenities = AmenitySerializer(many=True)
    parking = ParkingSerializer(many=True)
