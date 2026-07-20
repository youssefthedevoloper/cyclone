from rest_framework import filters, permissions, viewsets

from .models import Airport
from .serializers import AirportSerializer


class AirportViewSet(viewsets.ReadOnlyModelViewSet):
    queryset = Airport.objects.all()
    serializer_class = AirportSerializer
    permission_classes = [permissions.IsAuthenticated]

    filter_backends = [filters.SearchFilter, filters.OrderingFilter]
    search_fields = ['code', 'name', 'city', 'country']
    ordering_fields = ['name', 'code']

