import 'package:freezed_annotation/freezed_annotation.dart';

part 'flight_model.freezed.dart';
part 'flight_model.g.dart';

enum FlightStatus { scheduled, boarding, departed, arrived, delayed, cancelled }

@freezed
class FlightModel with _$FlightModel {
  const factory FlightModel({
    required String id,
    required String flightNumber,
    required String airline,
    required String airlineCode,
    required String departureAirport,
    required String departureCity,
    required String arrivalAirport,
    required String arrivalCity,
    required DateTime departureTime,
    required DateTime arrivalTime,
    required String terminal,
    required String gate,
    required String seat,
    required FlightStatus status,
    String? boardingGroup,
    DateTime? boardingTime,
    String? aircraft,
    int? delayMinutes,
    String? baggageClaim,
  }) = _FlightModel;

  factory FlightModel.fromJson(Map<String, dynamic> json) =>
      _$FlightModelFromJson(json);
}

extension FlightModelX on FlightModel {
  String get route => '$departureAirport → $arrivalAirport';
  String get statusLabel => switch (status) {
        FlightStatus.scheduled => 'Scheduled',
        FlightStatus.boarding => 'Boarding',
        FlightStatus.departed => 'Departed',
        FlightStatus.arrived => 'Arrived',
        FlightStatus.delayed => 'Delayed',
        FlightStatus.cancelled => 'Cancelled',
      };
  Duration get duration => arrivalTime.difference(departureTime);
}
