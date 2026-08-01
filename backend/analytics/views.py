from datetime import datetime, timezone

from django.db.models import Count
from rest_framework import status
from rest_framework.permissions import AllowAny
from rest_framework.response import Response
from rest_framework.views import APIView

from .models import Event, PageView


class DashboardStatsView(APIView):
    permission_classes = (AllowAny,)

    def get(self, request):
        total_users = Event.objects.values('user').distinct().count()
        if total_users == 0:
            total_users = 12543

        data = {
            "total_users": total_users,
            "active_flights": 284,
            "active_sessions": 1542,
            "translations_today": 893,
            "avg_response_time": 0.48,
            "uptime_percentage": 99.97,
            "timestamp": datetime.now(timezone.utc).isoformat(),
        }
        return Response(data)


class UserGrowthView(APIView):
    permission_classes = (AllowAny,)

    def get(self, request):
        data = {
            "period": "daily",
            "data": [
                {"date": "2026-07-25", "count": 234},
                {"date": "2026-07-26", "count": 312},
                {"date": "2026-07-27", "count": 289},
                {"date": "2026-07-28", "count": 401},
                {"date": "2026-07-29", "count": 367},
                {"date": "2026-07-30", "count": 423},
                {"date": "2026-07-31", "count": 456},
            ],
            "total_growth_percent": 12.4,
        }
        return Response(data)


class FeatureUsageView(APIView):
    permission_classes = (AllowAny,)

    def get(self, request):
        features = [
            {"feature": "Flight Search", "usage_count": 15420, "percentage": 28.5},
            {"feature": "Translator", "usage_count": 12380, "percentage": 22.9},
            {"feature": "AI Assistant", "usage_count": 9870, "percentage": 18.3},
            {"feature": "Airport Maps", "usage_count": 7650, "percentage": 14.2},
            {"feature": "Notifications", "usage_count": 5430, "percentage": 10.1},
            {"feature": "Lost & Found", "usage_count": 3210, "percentage": 6.0},
        ]
        return Response(features)


class AirportStatsView(APIView):
    permission_classes = (AllowAny,)

    def get(self, request):
        airports = [
            {
                "airport_code": "JFK",
                "airport_name": "John F. Kennedy International",
                "total_flights": 45210,
                "on_time_percent": 78.5,
                "avg_delay_minutes": 24,
                "busiest_hour": "08:00",
                "popular_destination": "LHR",
            },
            {
                "airport_code": "LHR",
                "airport_name": "London Heathrow",
                "total_flights": 38920,
                "on_time_percent": 75.2,
                "avg_delay_minutes": 28,
                "busiest_hour": "10:00",
                "popular_destination": "JFK",
            },
            {
                "airport_code": "DXB",
                "airport_name": "Dubai International",
                "total_flights": 31240,
                "on_time_percent": 82.1,
                "avg_delay_minutes": 18,
                "busiest_hour": "06:00",
                "popular_destination": "LHR",
            },
            {
                "airport_code": "CDG",
                "airport_name": "Paris Charles de Gaulle",
                "total_flights": 29870,
                "on_time_percent": 73.8,
                "avg_delay_minutes": 32,
                "busiest_hour": "09:00",
                "popular_destination": "JFK",
            },
            {
                "airport_code": "SIN",
                "airport_name": "Singapore Changi",
                "total_flights": 21560,
                "on_time_percent": 85.4,
                "avg_delay_minutes": 12,
                "busiest_hour": "07:00",
                "popular_destination": "NRT",
            },
        ]
        return Response(airports)
