from rest_framework import serializers


class EmergencyAlertSerializer(serializers.Serializer):
    contact_name = serializers.CharField(max_length=255)
    contact_phone = serializers.CharField(max_length=50)
    message = serializers.CharField(max_length=500)
