// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'flight_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

FlightModel _$FlightModelFromJson(Map<String, dynamic> json) {
  return _FlightModel.fromJson(json);
}

/// @nodoc
mixin _$FlightModel {
  String get id => throw _privateConstructorUsedError;
  String get flightNumber => throw _privateConstructorUsedError;
  String get airline => throw _privateConstructorUsedError;
  String get airlineCode => throw _privateConstructorUsedError;
  String get departureAirport => throw _privateConstructorUsedError;
  String get departureCity => throw _privateConstructorUsedError;
  String get arrivalAirport => throw _privateConstructorUsedError;
  String get arrivalCity => throw _privateConstructorUsedError;
  DateTime get departureTime => throw _privateConstructorUsedError;
  DateTime get arrivalTime => throw _privateConstructorUsedError;
  String get terminal => throw _privateConstructorUsedError;
  String get gate => throw _privateConstructorUsedError;
  String get seat => throw _privateConstructorUsedError;
  FlightStatus get status => throw _privateConstructorUsedError;
  String? get boardingGroup => throw _privateConstructorUsedError;
  DateTime? get boardingTime => throw _privateConstructorUsedError;
  String? get aircraft => throw _privateConstructorUsedError;
  int? get delayMinutes => throw _privateConstructorUsedError;
  String? get baggageClaim => throw _privateConstructorUsedError;

  /// Serializes this FlightModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FlightModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FlightModelCopyWith<FlightModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FlightModelCopyWith<$Res> {
  factory $FlightModelCopyWith(
    FlightModel value,
    $Res Function(FlightModel) then,
  ) = _$FlightModelCopyWithImpl<$Res, FlightModel>;
  @useResult
  $Res call({
    String id,
    String flightNumber,
    String airline,
    String airlineCode,
    String departureAirport,
    String departureCity,
    String arrivalAirport,
    String arrivalCity,
    DateTime departureTime,
    DateTime arrivalTime,
    String terminal,
    String gate,
    String seat,
    FlightStatus status,
    String? boardingGroup,
    DateTime? boardingTime,
    String? aircraft,
    int? delayMinutes,
    String? baggageClaim,
  });
}

/// @nodoc
class _$FlightModelCopyWithImpl<$Res, $Val extends FlightModel>
    implements $FlightModelCopyWith<$Res> {
  _$FlightModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FlightModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? flightNumber = null,
    Object? airline = null,
    Object? airlineCode = null,
    Object? departureAirport = null,
    Object? departureCity = null,
    Object? arrivalAirport = null,
    Object? arrivalCity = null,
    Object? departureTime = null,
    Object? arrivalTime = null,
    Object? terminal = null,
    Object? gate = null,
    Object? seat = null,
    Object? status = null,
    Object? boardingGroup = freezed,
    Object? boardingTime = freezed,
    Object? aircraft = freezed,
    Object? delayMinutes = freezed,
    Object? baggageClaim = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            flightNumber: null == flightNumber
                ? _value.flightNumber
                : flightNumber // ignore: cast_nullable_to_non_nullable
                      as String,
            airline: null == airline
                ? _value.airline
                : airline // ignore: cast_nullable_to_non_nullable
                      as String,
            airlineCode: null == airlineCode
                ? _value.airlineCode
                : airlineCode // ignore: cast_nullable_to_non_nullable
                      as String,
            departureAirport: null == departureAirport
                ? _value.departureAirport
                : departureAirport // ignore: cast_nullable_to_non_nullable
                      as String,
            departureCity: null == departureCity
                ? _value.departureCity
                : departureCity // ignore: cast_nullable_to_non_nullable
                      as String,
            arrivalAirport: null == arrivalAirport
                ? _value.arrivalAirport
                : arrivalAirport // ignore: cast_nullable_to_non_nullable
                      as String,
            arrivalCity: null == arrivalCity
                ? _value.arrivalCity
                : arrivalCity // ignore: cast_nullable_to_non_nullable
                      as String,
            departureTime: null == departureTime
                ? _value.departureTime
                : departureTime // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            arrivalTime: null == arrivalTime
                ? _value.arrivalTime
                : arrivalTime // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            terminal: null == terminal
                ? _value.terminal
                : terminal // ignore: cast_nullable_to_non_nullable
                      as String,
            gate: null == gate
                ? _value.gate
                : gate // ignore: cast_nullable_to_non_nullable
                      as String,
            seat: null == seat
                ? _value.seat
                : seat // ignore: cast_nullable_to_non_nullable
                      as String,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as FlightStatus,
            boardingGroup: freezed == boardingGroup
                ? _value.boardingGroup
                : boardingGroup // ignore: cast_nullable_to_non_nullable
                      as String?,
            boardingTime: freezed == boardingTime
                ? _value.boardingTime
                : boardingTime // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            aircraft: freezed == aircraft
                ? _value.aircraft
                : aircraft // ignore: cast_nullable_to_non_nullable
                      as String?,
            delayMinutes: freezed == delayMinutes
                ? _value.delayMinutes
                : delayMinutes // ignore: cast_nullable_to_non_nullable
                      as int?,
            baggageClaim: freezed == baggageClaim
                ? _value.baggageClaim
                : baggageClaim // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$FlightModelImplCopyWith<$Res>
    implements $FlightModelCopyWith<$Res> {
  factory _$$FlightModelImplCopyWith(
    _$FlightModelImpl value,
    $Res Function(_$FlightModelImpl) then,
  ) = __$$FlightModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String flightNumber,
    String airline,
    String airlineCode,
    String departureAirport,
    String departureCity,
    String arrivalAirport,
    String arrivalCity,
    DateTime departureTime,
    DateTime arrivalTime,
    String terminal,
    String gate,
    String seat,
    FlightStatus status,
    String? boardingGroup,
    DateTime? boardingTime,
    String? aircraft,
    int? delayMinutes,
    String? baggageClaim,
  });
}

/// @nodoc
class __$$FlightModelImplCopyWithImpl<$Res>
    extends _$FlightModelCopyWithImpl<$Res, _$FlightModelImpl>
    implements _$$FlightModelImplCopyWith<$Res> {
  __$$FlightModelImplCopyWithImpl(
    _$FlightModelImpl _value,
    $Res Function(_$FlightModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of FlightModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? flightNumber = null,
    Object? airline = null,
    Object? airlineCode = null,
    Object? departureAirport = null,
    Object? departureCity = null,
    Object? arrivalAirport = null,
    Object? arrivalCity = null,
    Object? departureTime = null,
    Object? arrivalTime = null,
    Object? terminal = null,
    Object? gate = null,
    Object? seat = null,
    Object? status = null,
    Object? boardingGroup = freezed,
    Object? boardingTime = freezed,
    Object? aircraft = freezed,
    Object? delayMinutes = freezed,
    Object? baggageClaim = freezed,
  }) {
    return _then(
      _$FlightModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        flightNumber: null == flightNumber
            ? _value.flightNumber
            : flightNumber // ignore: cast_nullable_to_non_nullable
                  as String,
        airline: null == airline
            ? _value.airline
            : airline // ignore: cast_nullable_to_non_nullable
                  as String,
        airlineCode: null == airlineCode
            ? _value.airlineCode
            : airlineCode // ignore: cast_nullable_to_non_nullable
                  as String,
        departureAirport: null == departureAirport
            ? _value.departureAirport
            : departureAirport // ignore: cast_nullable_to_non_nullable
                  as String,
        departureCity: null == departureCity
            ? _value.departureCity
            : departureCity // ignore: cast_nullable_to_non_nullable
                  as String,
        arrivalAirport: null == arrivalAirport
            ? _value.arrivalAirport
            : arrivalAirport // ignore: cast_nullable_to_non_nullable
                  as String,
        arrivalCity: null == arrivalCity
            ? _value.arrivalCity
            : arrivalCity // ignore: cast_nullable_to_non_nullable
                  as String,
        departureTime: null == departureTime
            ? _value.departureTime
            : departureTime // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        arrivalTime: null == arrivalTime
            ? _value.arrivalTime
            : arrivalTime // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        terminal: null == terminal
            ? _value.terminal
            : terminal // ignore: cast_nullable_to_non_nullable
                  as String,
        gate: null == gate
            ? _value.gate
            : gate // ignore: cast_nullable_to_non_nullable
                  as String,
        seat: null == seat
            ? _value.seat
            : seat // ignore: cast_nullable_to_non_nullable
                  as String,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as FlightStatus,
        boardingGroup: freezed == boardingGroup
            ? _value.boardingGroup
            : boardingGroup // ignore: cast_nullable_to_non_nullable
                  as String?,
        boardingTime: freezed == boardingTime
            ? _value.boardingTime
            : boardingTime // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        aircraft: freezed == aircraft
            ? _value.aircraft
            : aircraft // ignore: cast_nullable_to_non_nullable
                  as String?,
        delayMinutes: freezed == delayMinutes
            ? _value.delayMinutes
            : delayMinutes // ignore: cast_nullable_to_non_nullable
                  as int?,
        baggageClaim: freezed == baggageClaim
            ? _value.baggageClaim
            : baggageClaim // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$FlightModelImpl implements _FlightModel {
  const _$FlightModelImpl({
    required this.id,
    required this.flightNumber,
    required this.airline,
    required this.airlineCode,
    required this.departureAirport,
    required this.departureCity,
    required this.arrivalAirport,
    required this.arrivalCity,
    required this.departureTime,
    required this.arrivalTime,
    required this.terminal,
    required this.gate,
    required this.seat,
    required this.status,
    this.boardingGroup,
    this.boardingTime,
    this.aircraft,
    this.delayMinutes,
    this.baggageClaim,
  });

  factory _$FlightModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$FlightModelImplFromJson(json);

  @override
  final String id;
  @override
  final String flightNumber;
  @override
  final String airline;
  @override
  final String airlineCode;
  @override
  final String departureAirport;
  @override
  final String departureCity;
  @override
  final String arrivalAirport;
  @override
  final String arrivalCity;
  @override
  final DateTime departureTime;
  @override
  final DateTime arrivalTime;
  @override
  final String terminal;
  @override
  final String gate;
  @override
  final String seat;
  @override
  final FlightStatus status;
  @override
  final String? boardingGroup;
  @override
  final DateTime? boardingTime;
  @override
  final String? aircraft;
  @override
  final int? delayMinutes;
  @override
  final String? baggageClaim;

  @override
  String toString() {
    return 'FlightModel(id: $id, flightNumber: $flightNumber, airline: $airline, airlineCode: $airlineCode, departureAirport: $departureAirport, departureCity: $departureCity, arrivalAirport: $arrivalAirport, arrivalCity: $arrivalCity, departureTime: $departureTime, arrivalTime: $arrivalTime, terminal: $terminal, gate: $gate, seat: $seat, status: $status, boardingGroup: $boardingGroup, boardingTime: $boardingTime, aircraft: $aircraft, delayMinutes: $delayMinutes, baggageClaim: $baggageClaim)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FlightModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.flightNumber, flightNumber) ||
                other.flightNumber == flightNumber) &&
            (identical(other.airline, airline) || other.airline == airline) &&
            (identical(other.airlineCode, airlineCode) ||
                other.airlineCode == airlineCode) &&
            (identical(other.departureAirport, departureAirport) ||
                other.departureAirport == departureAirport) &&
            (identical(other.departureCity, departureCity) ||
                other.departureCity == departureCity) &&
            (identical(other.arrivalAirport, arrivalAirport) ||
                other.arrivalAirport == arrivalAirport) &&
            (identical(other.arrivalCity, arrivalCity) ||
                other.arrivalCity == arrivalCity) &&
            (identical(other.departureTime, departureTime) ||
                other.departureTime == departureTime) &&
            (identical(other.arrivalTime, arrivalTime) ||
                other.arrivalTime == arrivalTime) &&
            (identical(other.terminal, terminal) ||
                other.terminal == terminal) &&
            (identical(other.gate, gate) || other.gate == gate) &&
            (identical(other.seat, seat) || other.seat == seat) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.boardingGroup, boardingGroup) ||
                other.boardingGroup == boardingGroup) &&
            (identical(other.boardingTime, boardingTime) ||
                other.boardingTime == boardingTime) &&
            (identical(other.aircraft, aircraft) ||
                other.aircraft == aircraft) &&
            (identical(other.delayMinutes, delayMinutes) ||
                other.delayMinutes == delayMinutes) &&
            (identical(other.baggageClaim, baggageClaim) ||
                other.baggageClaim == baggageClaim));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    id,
    flightNumber,
    airline,
    airlineCode,
    departureAirport,
    departureCity,
    arrivalAirport,
    arrivalCity,
    departureTime,
    arrivalTime,
    terminal,
    gate,
    seat,
    status,
    boardingGroup,
    boardingTime,
    aircraft,
    delayMinutes,
    baggageClaim,
  ]);

  /// Create a copy of FlightModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FlightModelImplCopyWith<_$FlightModelImpl> get copyWith =>
      __$$FlightModelImplCopyWithImpl<_$FlightModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FlightModelImplToJson(this);
  }
}

abstract class _FlightModel implements FlightModel {
  const factory _FlightModel({
    required final String id,
    required final String flightNumber,
    required final String airline,
    required final String airlineCode,
    required final String departureAirport,
    required final String departureCity,
    required final String arrivalAirport,
    required final String arrivalCity,
    required final DateTime departureTime,
    required final DateTime arrivalTime,
    required final String terminal,
    required final String gate,
    required final String seat,
    required final FlightStatus status,
    final String? boardingGroup,
    final DateTime? boardingTime,
    final String? aircraft,
    final int? delayMinutes,
    final String? baggageClaim,
  }) = _$FlightModelImpl;

  factory _FlightModel.fromJson(Map<String, dynamic> json) =
      _$FlightModelImpl.fromJson;

  @override
  String get id;
  @override
  String get flightNumber;
  @override
  String get airline;
  @override
  String get airlineCode;
  @override
  String get departureAirport;
  @override
  String get departureCity;
  @override
  String get arrivalAirport;
  @override
  String get arrivalCity;
  @override
  DateTime get departureTime;
  @override
  DateTime get arrivalTime;
  @override
  String get terminal;
  @override
  String get gate;
  @override
  String get seat;
  @override
  FlightStatus get status;
  @override
  String? get boardingGroup;
  @override
  DateTime? get boardingTime;
  @override
  String? get aircraft;
  @override
  int? get delayMinutes;
  @override
  String? get baggageClaim;

  /// Create a copy of FlightModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FlightModelImplCopyWith<_$FlightModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
