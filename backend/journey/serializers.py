from rest_framework import serializers

from .models import Journey, JourneyStep, TravelChecklist


class JourneyStepSerializer(serializers.ModelSerializer):
    class Meta:
        model = JourneyStep
        fields = '__all__'
        read_only_fields = ('id', 'journey', 'created_at', 'updated_at')


class TravelChecklistSerializer(serializers.ModelSerializer):
    class Meta:
        model = TravelChecklist
        fields = '__all__'
        read_only_fields = ('id', 'journey', 'created_at', 'updated_at')


class JourneySerializer(serializers.ModelSerializer):
    steps = JourneyStepSerializer(many=True, read_only=True)
    checklist_items = TravelChecklistSerializer(many=True, read_only=True)

    class Meta:
        model = Journey
        fields = '__all__'
        read_only_fields = ('id', 'user', 'created_at', 'updated_at')
