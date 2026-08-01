from rest_framework import serializers

from .models import FoundItem, LostItem


class LostItemSerializer(serializers.ModelSerializer):
    class Meta:
        model = LostItem
        fields = '__all__'
        read_only_fields = ('id', 'user', 'date_reported', 'qr_tracking_code', 'ai_classification', 'created_at', 'updated_at')


class FoundItemSerializer(serializers.ModelSerializer):
    class Meta:
        model = FoundItem
        fields = '__all__'
        read_only_fields = ('id', 'reported_by', 'date_found')


class LostItemListSerializer(serializers.ModelSerializer):
    class Meta:
        model = LostItem
        fields = ('id', 'description', 'category', 'location_lost', 'date_reported', 'status', 'qr_tracking_code')


class LostItemTrackSerializer(serializers.Serializer):
    tracking_code = serializers.CharField(max_length=100)
