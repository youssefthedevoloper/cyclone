from rest_framework import generics, status
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response

from .models import Journey, JourneyStep, TravelChecklist
from .serializers import (
    JourneySerializer,
    JourneyStepSerializer,
    TravelChecklistSerializer,
)


class JourneyView(generics.RetrieveUpdateAPIView):
    serializer_class = JourneySerializer
    permission_classes = (IsAuthenticated,)

    def get_object(self):
        flight_id = self.request.query_params.get('flight_id')
        if flight_id:
            try:
                return Journey.objects.filter(
                    user=self.request.user,
                    flight_id=flight_id
                ).latest('created_at')
            except Journey.DoesNotExist:
                pass
        try:
            return Journey.objects.filter(user=self.request.user).latest('created_at')
        except Journey.DoesNotExist:
            return None

    def get(self, request, *args, **kwargs):
        journey = self.get_object()
        if journey is None:
            return Response({'detail': 'No journey found.'}, status=status.HTTP_404_NOT_FOUND)
        serializer = self.get_serializer(journey)
        return Response(serializer.data)

    def put(self, request, *args, **kwargs):
        journey = self.get_object()
        if journey is None:
            return Response({'detail': 'No journey found.'}, status=status.HTTP_404_NOT_FOUND)
        serializer = self.get_serializer(journey, data=request.data, partial=True)
        if not serializer.is_valid():
            return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
        serializer.save()
        return Response(serializer.data)


class JourneyStepView(generics.GenericAPIView):
    serializer_class = JourneyStepSerializer
    permission_classes = (IsAuthenticated,)

    def get_queryset(self):
        journey_id = self.request.query_params.get('journey_id')
        if not journey_id:
            return JourneyStep.objects.none()
        return JourneyStep.objects.filter(
            journey_id=journey_id,
            journey__user=self.request.user
        )

    def get(self, request, *args, **kwargs):
        journey_id = request.query_params.get('journey_id')
        if not journey_id:
            try:
                journey = Journey.objects.filter(user=request.user).latest('created_at')
                journey_id = journey.id
            except Journey.DoesNotExist:
                return Response({'detail': 'No journey found.'}, status=status.HTTP_404_NOT_FOUND)

        steps = self.get_queryset()
        current_step = None
        for step in steps:
            if not step.is_completed:
                current_step = step
                break

        serializer = self.get_serializer(steps, many=True)
        return Response({
            'steps': serializer.data,
            'current_step': JourneyStepSerializer(current_step).data if current_step else None,
        })

    def patch(self, request, *args, **kwargs):
        step_id = kwargs.get('pk')
        if not step_id:
            return Response({'error': 'Step ID required.'}, status=status.HTTP_400_BAD_REQUEST)
        try:
            step = JourneyStep.objects.get(
                id=step_id,
                journey__user=request.user
            )
        except JourneyStep.DoesNotExist:
            return Response({'error': 'Step not found.'}, status=status.HTTP_404_NOT_FOUND)

        step.is_completed = True
        step.save(update_fields=['is_completed'])
        serializer = self.get_serializer(step)
        return Response(serializer.data)


class ChecklistView(generics.GenericAPIView):
    serializer_class = TravelChecklistSerializer
    permission_classes = (IsAuthenticated,)

    def get_queryset(self):
        journey_id = self.request.query_params.get('journey_id')
        if not journey_id:
            return TravelChecklist.objects.none()
        return TravelChecklist.objects.filter(
            journey_id=journey_id,
            journey__user=self.request.user
        )

    def get(self, request, *args, **kwargs):
        journey_id = request.query_params.get('journey_id')
        if not journey_id:
            try:
                journey = Journey.objects.filter(user=request.user).latest('created_at')
                journey_id = journey.id
            except Journey.DoesNotExist:
                return Response({'detail': 'No journey found.'}, status=status.HTTP_404_NOT_FOUND)

        items = self.get_queryset()
        serializer = self.get_serializer(items, many=True)
        return Response(serializer.data)

    def patch(self, request, *args, **kwargs):
        item_id = kwargs.get('pk')
        if not item_id:
            return Response({'error': 'Item ID required.'}, status=status.HTTP_400_BAD_REQUEST)
        try:
            item = TravelChecklist.objects.get(id=item_id, journey__user=request.user)
        except TravelChecklist.DoesNotExist:
            return Response({'error': 'Checklist item not found.'}, status=status.HTTP_404_NOT_FOUND)

        is_packed = request.data.get('is_packed')
        if is_packed is not None:
            item.is_packed = bool(is_packed)
            item.save(update_fields=['is_packed'])

        serializer = self.get_serializer(item)
        return Response(serializer.data)
