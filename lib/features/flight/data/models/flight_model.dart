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

  factory FlightModel.fromApiJson(Map<String, dynamic> json) {
    String str(dynamic v, [String fallback = '']) => v?.toString() ?? fallback;

    String nested(dynamic parent, String field) {
      if (parent is Map) {
        final v = parent[field];
        return v?.toString() ?? '';
      }
      return '';
    }

    final airline = json['airline'];
    final departureAirport = json['departure_airport'];
    final arrivalAirport = json['arrival_airport'];

    return FlightModel.fromJson({
      'id': str(json['id']),
      'flightNumber': str(json['flight_number'] ?? json['flightNumber']),
      'airline': nested(airline, 'name').isNotEmpty
          ? nested(airline, 'name')
          : str(json['airline_name'] ?? json['airline']),
      'airlineCode': nested(airline, 'code').isNotEmpty
          ? nested(airline, 'code')
          : str(json['airline_code'] ?? json['airlineCode']),
      'departureAirport': nested(departureAirport, 'code').isNotEmpty
          ? nested(departureAirport, 'code')
          : str(json['departure_code'] ?? json['departureAirport']),
      'departureCity': nested(departureAirport, 'city').isNotEmpty
          ? nested(departureAirport, 'city')
          : str(json['departure_city'] ?? json['departureCity']),
      'arrivalAirport': nested(arrivalAirport, 'code').isNotEmpty
          ? nested(arrivalAirport, 'code')
          : str(json['arrival_code'] ?? json['arrivalAirport']),
      'arrivalCity': nested(arrivalAirport, 'city').isNotEmpty
          ? nested(arrivalAirport, 'city')
          : str(json['arrival_city'] ?? json['arrivalCity']),
      'departureTime':
          str(json['departure_time'] ?? json['departureTime'], DateTime.now().toIso8601String()),
      'arrivalTime':
          str(json['arrival_time'] ?? json['arrivalTime'], DateTime.now().toIso8601String()),
      'terminal': str(json['terminal']),
      'gate': str(json['gate']),
      'seat': str(json['seat']),
      'status': str(json['status'], 'scheduled'),
      'boardingGroup': json['boarding_group'],
      'boardingTime': json['boarding_time'],
      'aircraft': json['aircraft'],
      'delayMinutes': json['delay_minutes'],
      'baggageClaim': json['baggage_claim'] ?? json['baggageClaim'],
    });
  }
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
