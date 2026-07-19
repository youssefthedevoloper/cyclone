// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'flight_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FlightModelImpl _$$FlightModelImplFromJson(Map<String, dynamic> json) =>
    _$FlightModelImpl(
      id: json['id'] as String,
      flightNumber: json['flightNumber'] as String,
      airline: json['airline'] as String,
      airlineCode: json['airlineCode'] as String,
      departureAirport: json['departureAirport'] as String,
      departureCity: json['departureCity'] as String,
      arrivalAirport: json['arrivalAirport'] as String,
      arrivalCity: json['arrivalCity'] as String,
      departureTime: DateTime.parse(json['departureTime'] as String),
      arrivalTime: DateTime.parse(json['arrivalTime'] as String),
      terminal: json['terminal'] as String,
      gate: json['gate'] as String,
      seat: json['seat'] as String,
      status: $enumDecode(_$FlightStatusEnumMap, json['status']),
      boardingGroup: json['boardingGroup'] as String?,
      boardingTime: json['boardingTime'] == null
          ? null
          : DateTime.parse(json['boardingTime'] as String),
      aircraft: json['aircraft'] as String?,
      delayMinutes: (json['delayMinutes'] as num?)?.toInt(),
      baggageClaim: json['baggageClaim'] as String?,
    );

Map<String, dynamic> _$$FlightModelImplToJson(_$FlightModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'flightNumber': instance.flightNumber,
      'airline': instance.airline,
      'airlineCode': instance.airlineCode,
      'departureAirport': instance.departureAirport,
      'departureCity': instance.departureCity,
      'arrivalAirport': instance.arrivalAirport,
      'arrivalCity': instance.arrivalCity,
      'departureTime': instance.departureTime.toIso8601String(),
      'arrivalTime': instance.arrivalTime.toIso8601String(),
      'terminal': instance.terminal,
      'gate': instance.gate,
      'seat': instance.seat,
      'status': _$FlightStatusEnumMap[instance.status]!,
      'boardingGroup': instance.boardingGroup,
      'boardingTime': instance.boardingTime?.toIso8601String(),
      'aircraft': instance.aircraft,
      'delayMinutes': instance.delayMinutes,
      'baggageClaim': instance.baggageClaim,
    };

const _$FlightStatusEnumMap = {
  FlightStatus.scheduled: 'scheduled',
  FlightStatus.boarding: 'boarding',
  FlightStatus.departed: 'departed',
  FlightStatus.arrived: 'arrived',
  FlightStatus.delayed: 'delayed',
  FlightStatus.cancelled: 'cancelled',
};
