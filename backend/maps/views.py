from rest_framework import status
from rest_framework.permissions import AllowAny
from rest_framework.response import Response
from rest_framework.views import APIView

from .data import JFK_AIRPORT_DATA


class AirportMapView(APIView):
    permission_classes = (AllowAny,)

    def get(self, request, code="JFK"):
        if code.upper() != "JFK":
            return Response({"error": f"Airport data for '{code}' is not available"}, status=status.HTTP_404_NOT_FOUND)
        return Response(JFK_AIRPORT_DATA)


class SearchAmenitiesView(APIView):
    permission_classes = (AllowAny,)

    def get(self, request):
        query = request.query_params.get("q", "").lower().strip()
        terminal = request.query_params.get("terminal")

        amenities = JFK_AIRPORT_DATA["amenities"]

        if query:
            filtered = []
            for a in amenities:
                if (query in a["name"].lower()
                        or query in a["type"].lower()
                        or query in a["description"].lower()):
                    filtered.append(a)
            amenities = filtered

        if terminal:
            filtered = []
            for a in amenities:
                if terminal.lower() in a["terminal"].lower():
                    filtered.append(a)
            amenities = filtered

        return Response(amenities)


class TerminalDetailView(APIView):
    permission_classes = (AllowAny,)

    def get(self, request, terminal):
        terminals = JFK_AIRPORT_DATA["terminals"]
        target = None
        for t in terminals:
            if str(t["number"]) == str(terminal):
                target = dict(t)
                break
            if terminal.lower() in t["name"].lower():
                target = dict(t)
                break

        if not target:
            return Response({"error": f"Terminal '{terminal}' not found"}, status=status.HTTP_404_NOT_FOUND)

        target["gates"] = JFK_AIRPORT_DATA["gates"].get(target["name"], [])

        terminal_amenities = []
        for a in JFK_AIRPORT_DATA["amenities"]:
            if a["terminal"] == target["name"]:
                terminal_amenities.append(a)
        target["amenities"] = terminal_amenities

        terminal_parking = []
        for p in JFK_AIRPORT_DATA["parking"]:
            if p["terminal"] == target["name"] or p["terminal"] == "All Terminals":
                terminal_parking.append(p)
        target["parking"] = terminal_parking

        return Response(target)
