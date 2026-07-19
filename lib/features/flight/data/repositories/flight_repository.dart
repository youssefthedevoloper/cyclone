import '../models/flight_model.dart';

class FlightRepository {
  Future<List<FlightModel>> getUpcomingFlights() async {
    await Future<void>.delayed(const Duration(milliseconds: 600));
    return _mockFlights.where((f) => f.status != FlightStatus.arrived).toList();
  }

  Future<List<FlightModel>> getPastFlights() async {
    await Future<void>.delayed(const Duration(milliseconds: 600));
    return _mockFlights.where((f) => f.status == FlightStatus.arrived).toList();
  }

  Future<FlightModel?> getFlightById(String id) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    try {
      return _mockFlights.firstWhere((f) => f.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<List<FlightModel>> searchFlights(String query) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    if (query.isEmpty) return getUpcomingFlights();
    final lower = query.toLowerCase();
    return _mockFlights.where((f) {
      return f.flightNumber.toLowerCase().contains(lower) ||
          f.departureCity.toLowerCase().contains(lower) ||
          f.arrivalCity.toLowerCase().contains(lower) ||
          f.airline.toLowerCase().contains(lower);
    }).toList();
  }

  static final _mockFlights = [
    FlightModel(
      id: 'fl_001',
      flightNumber: 'CY 2847',
      airline: 'Cyclone Airways',
      airlineCode: 'CY',
      departureAirport: 'JFK',
      departureCity: 'New York',
      arrivalAirport: 'LHR',
      arrivalCity: 'London',
      departureTime: DateTime.now().add(const Duration(hours: 3)),
      arrivalTime: DateTime.now().add(const Duration(hours: 10)),
      terminal: 'Terminal 4',
      gate: 'B22',
      seat: '14A',
      status: FlightStatus.boarding,
      boardingGroup: '2',
      boardingTime: DateTime.now().add(const Duration(minutes: 45)),
      aircraft: 'Boeing 787-9',
    ),
    FlightModel(
      id: 'fl_002',
      flightNumber: 'BA 178',
      airline: 'British Airways',
      airlineCode: 'BA',
      departureAirport: 'LHR',
      departureCity: 'London',
      arrivalAirport: 'JFK',
      arrivalCity: 'New York',
      departureTime: DateTime.now().add(const Duration(days: 7)),
      arrivalTime: DateTime.now().add(const Duration(days: 7, hours: 8)),
      terminal: 'Terminal 5',
      gate: 'A12',
      seat: '22C',
      status: FlightStatus.scheduled,
      boardingGroup: '3',
      boardingTime: DateTime.now().add(const Duration(days: 7, hours: -1)),
      aircraft: 'Airbus A380',
    ),
    FlightModel(
      id: 'fl_003',
      flightNumber: 'EK 201',
      airline: 'Emirates',
      airlineCode: 'EK',
      departureAirport: 'DXB',
      departureCity: 'Dubai',
      arrivalAirport: 'JFK',
      arrivalCity: 'New York',
      departureTime: DateTime.now().subtract(const Duration(days: 14)),
      arrivalTime: DateTime.now().subtract(const Duration(days: 14, hours: -14)),
      terminal: 'Terminal 3',
      gate: 'C8',
      seat: '8F',
      status: FlightStatus.arrived,
      aircraft: 'Boeing 777-300ER',
      baggageClaim: 'Carousel 4',
    ),
  ];
}
