from django.db.models import Q
from django.utils import timezone
from rest_framework import generics, status
from rest_framework.permissions import AllowAny
from rest_framework.response import Response
from rest_framework.views import APIView

from .demo import DemoFlightEngine
from .models import Flight
from .serializers import FlightListSerializer, FlightSerializer


class FlightListView(generics.ListAPIView):
    queryset = Flight.objects.select_related(
        'airline', 'departure_airport', 'arrival_airport'
    ).all()
    serializer_class = FlightListSerializer
    permission_classes = (AllowAny,)

    def get_queryset(self):
        qs = super().get_queryset()
        status_param = self.request.query_params.get('status')
        date_param = self.request.query_params.get('date')
        airport_param = self.request.query_params.get('airport')

        if status_param:
            if status_param == 'upcoming':
                qs = qs.filter(departure_time__gte=timezone.now()).exclude(status='cancelled')
            elif status_param == 'past':
                qs = qs.filter(arrival_time__lt=timezone.now())
            else:
                qs = qs.filter(status=status_param)
        if date_param:
            qs = qs.filter(departure_time__date=date_param)
        if airport_param:
            qs = qs.filter(
                Q(departure_airport__code__iexact=airport_param) |
                Q(arrival_airport__code__iexact=airport_param) |
                Q(departure_airport__city__iexact=airport_param) |
                Q(arrival_airport__city__iexact=airport_param)
            )
        return qs


class FlightDetailView(generics.RetrieveAPIView):
    queryset = Flight.objects.select_related(
        'airline', 'departure_airport', 'arrival_airport'
    ).all()
    serializer_class = FlightSerializer
    permission_classes = (AllowAny,)
    lookup_field = 'id'


class FlightSearchView(generics.ListAPIView):
    serializer_class = FlightListSerializer
    permission_classes = (AllowAny,)

    def get_queryset(self):
        q = self.request.query_params.get('q', '')
        if not q:
            return Flight.objects.none()
        qs = Flight.objects.select_related(
            'airline', 'departure_airport', 'arrival_airport'
        ).filter(
            Q(flight_number__icontains=q) |
            Q(airline__name__icontains=q) |
            Q(airline__code__icontains=q) |
            Q(departure_airport__city__icontains=q) |
            Q(departure_airport__code__icontains=q) |
            Q(arrival_airport__city__icontains=q) |
            Q(arrival_airport__code__icontains=q)
        )
        return qs


class LiveFlightTracker(APIView):
    permission_classes = (AllowAny,)

    def get(self, request):
        try:
            DemoFlightEngine.seed()
            feed = DemoFlightEngine.get_live_feed()
            return Response(feed)
        except Exception as e:
            return Response(
                {'error': 'Failed to retrieve live flight data.', 'detail': str(e)},
                status=status.HTTP_500_INTERNAL_SERVER_ERROR
            )
