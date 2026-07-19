import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/flight_model.dart';
import '../../data/repositories/flight_repository.dart';

final flightRepositoryProvider = Provider<FlightRepository>(
  (ref) => FlightRepository(),
);

final upcomingFlightsProvider = FutureProvider<List<FlightModel>>((ref) async {
  return ref.watch(flightRepositoryProvider).getUpcomingFlights();
});

final pastFlightsProvider = FutureProvider<List<FlightModel>>((ref) async {
  return ref.watch(flightRepositoryProvider).getPastFlights();
});

final flightDetailProvider = FutureProvider.family<FlightModel?, String>((ref, id) async {
  return ref.watch(flightRepositoryProvider).getFlightById(id);
});

final flightSearchProvider =
    StateNotifierProvider<FlightSearchNotifier, AsyncValue<List<FlightModel>>>((ref) {
  return FlightSearchNotifier(ref.watch(flightRepositoryProvider));
});

class FlightSearchNotifier extends StateNotifier<AsyncValue<List<FlightModel>>> {
  FlightSearchNotifier(this._repository) : super(const AsyncValue.loading()) {
    _load();
  }

  final FlightRepository _repository;

  Future<void> _load() async {
    state = const AsyncValue.loading();
    try {
      final flights = await _repository.getUpcomingFlights();
      state = AsyncValue.data(flights);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> search(String query) async {
    state = const AsyncValue.loading();
    try {
      final flights = await _repository.searchFlights(query);
      state = AsyncValue.data(flights);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
