from rest_framework import serializers

from .models import Event, PageView


class EventSerializer(serializers.ModelSerializer):
    class Meta:
        model = Event
        fields = ('id', 'user', 'event_type', 'properties', 'session_id', 'created_at')
        read_only_fields = ('id', 'created_at')


class PageViewSerializer(serializers.ModelSerializer):
    class Meta:
        model = PageView
        fields = ('id', 'user', 'path', 'duration_seconds', 'created_at')
        read_only_fields = ('id', 'created_at')


class DashboardStatsSerializer(serializers.Serializer):
    total_users = serializers.IntegerField()
    active_flights = serializers.IntegerField()
    active_sessions = serializers.IntegerField()
    translations_today = serializers.IntegerField()
    avg_response_time = serializers.FloatField()
    uptime_percentage = serializers.FloatField()
    timestamp = serializers.DateTimeField()


class GrowthDataPointSerializer(serializers.Serializer):
    date = serializers.CharField()
    count = serializers.IntegerField()


class UserGrowthSerializer(serializers.Serializer):
    period = serializers.CharField()
    data = GrowthDataPointSerializer(many=True)
    total_growth_percent = serializers.FloatField()


class FeatureUsageSerializer(serializers.Serializer):
    feature = serializers.CharField()
    usage_count = serializers.IntegerField()
    percentage = serializers.FloatField()


class AirportStatSerializer(serializers.Serializer):
    airport_code = serializers.CharField()
    airport_name = serializers.CharField()
    total_flights = serializers.IntegerField()
    on_time_percent = serializers.FloatField()
    avg_delay_minutes = serializers.IntegerField()
    busiest_hour = serializers.CharField()
    popular_destination = serializers.CharField()
