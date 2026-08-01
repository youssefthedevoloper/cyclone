from rest_framework import status
from rest_framework.authentication import TokenAuthentication
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from rest_framework.views import APIView

EMERGENCY_CONTACTS = {
    'general': {
        'police': '+123-456-7890',
        'fire': '+123-456-7891',
        'ambulance': '+123-456-7892',
        'airport_emergency': '+123-456-7893',
    },
    'embassies': {
        'usa': '+123-456-7900',
        'uk': '+123-456-7901',
        'canada': '+123-456-7902',
        'australia': '+123-456-7903',
        'india': '+123-456-7904',
        'uae': '+123-456-7905',
    },
    'medical': {
        'first_aid': '+123-456-7910',
        'hospital': '+123-456-7911',
        'pharmacy': '+123-456-7912',
    },
}

AIRPORT_HELP = {
    'info_desks': [
        {'terminal': 'Terminal 1', 'location': 'Arrivals Hall, Gate A', 'hours': '24/7'},
        {'terminal': 'Terminal 2', 'location': 'Departures Level, Gate C', 'hours': '24/7'},
        {'terminal': 'Terminal 3', 'location': 'Central Atrium', 'hours': '05:00 - 23:00'},
    ],
    'lost_and_found_offices': [
        {'terminal': 'Terminal 1', 'location': 'Near Gate A12', 'phone': '+123-456-7920', 'hours': '08:00 - 20:00'},
        {'terminal': 'Terminal 2', 'location': 'Near Baggage Claim 5', 'phone': '+123-456-7921', 'hours': '08:00 - 20:00'},
    ],
    'medical_stations': [
        {'terminal': 'Terminal 1', 'location': 'Near Gate B5', 'phone': '+123-456-7930'},
        {'terminal': 'Terminal 2', 'location': 'Near Gate D10', 'phone': '+123-456-7931'},
        {'terminal': 'Terminal 3', 'location': 'Central Atrium, Level 2', 'phone': '+123-456-7932'},
    ],
}


class EmergencyContactsView(APIView):
    authentication_classes = (TokenAuthentication,)
    permission_classes = (IsAuthenticated,)

    def get(self, request):
        return Response(EMERGENCY_CONTACTS)


class AirportHelpView(APIView):
    authentication_classes = (TokenAuthentication,)
    permission_classes = (IsAuthenticated,)

    def get(self, request):
        return Response(AIRPORT_HELP)


class SendEmergencyAlertView(APIView):
    authentication_classes = (TokenAuthentication,)
    permission_classes = (IsAuthenticated,)

    def post(self, request):
        try:
            contact_name = request.data.get('contact_name', '')
            contact_phone = request.data.get('contact_phone', '')
            message = request.data.get('message', '')
            user_location = request.data.get('location', 'Unknown')

            if not contact_name or not contact_phone:
                contact_name = request.user.emergency_contact_name or contact_name
                contact_phone = request.user.emergency_contact_phone or contact_phone

            if not contact_name or not contact_phone:
                return Response(
                    {'error': 'No emergency contact configured. Provide contact_name and contact_phone.'},
                    status=status.HTTP_400_BAD_REQUEST,
                )

            alert_body = (
                f'EMERGENCY ALERT from {request.user.email}\n'
                f'Message: {message or "Help needed"}\n'
                f'Location: {user_location}\n'
                f'Please contact immediately.'
            )

            return Response({
                'status': 'alert_sent',
                'contact_name': contact_name,
                'contact_phone': contact_phone,
                'message': alert_body,
            }, status=status.HTTP_200_OK)
        except Exception as e:
            return Response({'error': 'Failed to send emergency alert.', 'detail': str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)
