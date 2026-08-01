import random
from datetime import datetime, timedelta

from django.utils import timezone

from .models import Airport, Airline, Flight, FlightUpdate


AIRPORTS = [
    {'code': 'JFK', 'name': 'John F. Kennedy International Airport', 'city': 'New York', 'country': 'USA', 'terminal_count': 6, 'lat': 40.6413, 'lng': -73.7781, 'timezone': 'America/New_York'},
    {'code': 'LHR', 'name': 'London Heathrow Airport', 'city': 'London', 'country': 'United Kingdom', 'terminal_count': 4, 'lat': 51.4700, 'lng': -0.4543, 'timezone': 'Europe/London'},
    {'code': 'DXB', 'name': 'Dubai International Airport', 'city': 'Dubai', 'country': 'UAE', 'terminal_count': 3, 'lat': 25.2532, 'lng': 55.3657, 'timezone': 'Asia/Dubai'},
    {'code': 'CDG', 'name': 'Charles de Gaulle Airport', 'city': 'Paris', 'country': 'France', 'terminal_count': 3, 'lat': 49.0097, 'lng': 2.5479, 'timezone': 'Europe/Paris'},
    {'code': 'HND', 'name': 'Tokyo Haneda Airport', 'city': 'Tokyo', 'country': 'Japan', 'terminal_count': 3, 'lat': 35.5494, 'lng': 139.7798, 'timezone': 'Asia/Tokyo'},
    {'code': 'SIN', 'name': 'Singapore Changi Airport', 'city': 'Singapore', 'country': 'Singapore', 'terminal_count': 4, 'lat': 1.3644, 'lng': 103.9915, 'timezone': 'Asia/Singapore'},
    {'code': 'LAX', 'name': 'Los Angeles International Airport', 'city': 'Los Angeles', 'country': 'USA', 'terminal_count': 9, 'lat': 33.9416, 'lng': -118.4085, 'timezone': 'America/Los_Angeles'},
    {'code': 'IST', 'name': 'Istanbul Airport', 'city': 'Istanbul', 'country': 'Turkey', 'terminal_count': 2, 'lat': 41.2608, 'lng': 28.7420, 'timezone': 'Europe/Istanbul'},
    {'code': 'FRA', 'name': 'Frankfurt Airport', 'city': 'Frankfurt', 'country': 'Germany', 'terminal_count': 2, 'lat': 50.0379, 'lng': 8.5622, 'timezone': 'Europe/Berlin'},
    {'code': 'AMS', 'name': 'Amsterdam Airport Schiphol', 'city': 'Amsterdam', 'country': 'Netherlands', 'terminal_count': 1, 'lat': 52.3105, 'lng': 4.7683, 'timezone': 'Europe/Amsterdam'},
    {'code': 'SYD', 'name': 'Sydney Kingsford Smith Airport', 'city': 'Sydney', 'country': 'Australia', 'terminal_count': 3, 'lat': -33.9399, 'lng': 151.1753, 'timezone': 'Australia/Sydney'},
    {'code': 'YYZ', 'name': 'Toronto Pearson International Airport', 'city': 'Toronto', 'country': 'Canada', 'terminal_count': 2, 'lat': 43.6777, 'lng': -79.6248, 'timezone': 'America/Toronto'},
    {'code': 'PEK', 'name': 'Beijing Capital International Airport', 'city': 'Beijing', 'country': 'China', 'terminal_count': 3, 'lat': 40.0799, 'lng': 116.6031, 'timezone': 'Asia/Shanghai'},
    {'code': 'MUC', 'name': 'Munich Airport', 'city': 'Munich', 'country': 'Germany', 'terminal_count': 2, 'lat': 48.3538, 'lng': 11.7861, 'timezone': 'Europe/Berlin'},
    {'code': 'DFW', 'name': 'Dallas/Fort Worth International Airport', 'city': 'Dallas', 'country': 'USA', 'terminal_count': 5, 'lat': 32.8998, 'lng': -97.0403, 'timezone': 'America/Chicago'},
]

AIRLINES = [
    {'code': 'AA', 'name': 'American Airlines', 'alliance': 'one_world'},
    {'code': 'UA', 'name': 'United Airlines', 'alliance': 'star_alliance'},
    {'code': 'DL', 'name': 'Delta Air Lines', 'alliance': 'sky_team'},
    {'code': 'EK', 'name': 'Emirates', 'alliance': 'none'},
    {'code': 'BA', 'name': 'British Airways', 'alliance': 'one_world'},
    {'code': 'AF', 'name': 'Air France', 'alliance': 'sky_team'},
    {'code': 'LH', 'name': 'Lufthansa', 'alliance': 'star_alliance'},
    {'code': 'SQ', 'name': 'Singapore Airlines', 'alliance': 'star_alliance'},
    {'code': 'TK', 'name': 'Turkish Airlines', 'alliance': 'star_alliance'},
    {'code': 'JL', 'name': 'Japan Airlines', 'alliance': 'one_world'},
]

FLIGHTS_DATA = [
    {'flight_number': 'AA100', 'airline_code': 'AA', 'departure': 'JFK', 'arrival': 'LHR', 'aircraft': 'Boeing 777-300ER'},
    {'flight_number': 'UA200', 'airline_code': 'UA', 'departure': 'LAX', 'arrival': 'HND', 'aircraft': 'Boeing 787-9'},
    {'flight_number': 'DL300', 'airline_code': 'DL', 'departure': 'JFK', 'arrival': 'CDG', 'aircraft': 'Airbus A330-300'},
    {'flight_number': 'EK400', 'airline_code': 'EK', 'departure': 'DXB', 'arrival': 'SYD', 'aircraft': 'Airbus A380-800'},
    {'flight_number': 'BA500', 'airline_code': 'BA', 'departure': 'LHR', 'arrival': 'JFK', 'aircraft': 'Boeing 747-400'},
    {'flight_number': 'AF600', 'airline_code': 'AF', 'departure': 'CDG', 'arrival': 'LAX', 'aircraft': 'Airbus A350-900'},
    {'flight_number': 'LH700', 'airline_code': 'LH', 'departure': 'FRA', 'arrival': 'SIN', 'aircraft': 'Airbus A380-800'},
    {'flight_number': 'SQ800', 'airline_code': 'SQ', 'departure': 'SIN', 'arrival': 'SYD', 'aircraft': 'Airbus A350-900'},
    {'flight_number': 'TK900', 'airline_code': 'TK', 'departure': 'IST', 'arrival': 'DXB', 'aircraft': 'Boeing 777-300ER'},
    {'flight_number': 'JL1000', 'airline_code': 'JL', 'departure': 'HND', 'arrival': 'SIN', 'aircraft': 'Boeing 787-9'},
    {'flight_number': 'AA1100', 'airline_code': 'AA', 'departure': 'DFW', 'arrival': 'LHR', 'aircraft': 'Boeing 777-200ER'},
    {'flight_number': 'UA1200', 'airline_code': 'UA', 'departure': 'YYZ', 'arrival': 'LAX', 'aircraft': 'Boeing 737-800'},
    {'flight_number': 'DL1300', 'airline_code': 'DL', 'departure': 'AMS', 'arrival': 'JFK', 'aircraft': 'Boeing 767-400'},
    {'flight_number': 'EK1400', 'airline_code': 'EK', 'departure': 'DXB', 'arrival': 'LHR', 'aircraft': 'Airbus A380-800'},
    {'flight_number': 'BA1500', 'airline_code': 'BA', 'departure': 'LHR', 'arrival': 'AMS', 'aircraft': 'Airbus A320neo'},
    {'flight_number': 'LH1600', 'airline_code': 'LH', 'departure': 'MUC', 'arrival': 'JFK', 'aircraft': 'Airbus A350-900'},
    {'flight_number': 'AF1700', 'airline_code': 'AF', 'departure': 'CDG', 'arrival': 'DXB', 'aircraft': 'Boeing 777-300ER'},
    {'flight_number': 'SQ1800', 'airline_code': 'SQ', 'departure': 'SIN', 'arrival': 'HND', 'aircraft': 'Airbus A380-800'},
]

STATUSES = ['scheduled', 'boarding', 'departed', 'arrived', 'delayed', 'cancelled']
GATES = [f'{c}{i}' for c in 'ABCDEFGH' for i in range(1, 10)]
TERMINALS = ['1', '2', '3', '4', '5']


class DemoFlightEngine:

    @classmethod
    def seed(cls):
        if Airport.objects.count() > 0 and Flight.objects.count() > 0:
            return

        airports = {}
        for data in AIRPORTS:
            airport, _ = Airport.objects.get_or_create(code=data['code'], defaults=data)
            airports[data['code']] = airport

        airlines = {}
        for data in AIRLINES:
            airline, _ = Airline.objects.get_or_create(code=data['code'], defaults=data)
            airlines[data['code']] = airline

        now = timezone.now()
        for f_data in FLIGHTS_DATA:
            airline = airlines[f_data['airline_code']]
            dep_airport = airports[f_data['departure']]
            arr_airport = airports[f_data['arrival']]

            dep_time = now + timedelta(hours=random.randint(1, 48), minutes=random.randint(0, 59))
            flight_time = random.randint(120, 720)
            arr_time = dep_time + timedelta(minutes=flight_time)

            status = random.choices(
                STATUSES,
                weights=[40, 10, 15, 10, 15, 10],
                k=1
            )[0]

            delay = random.randint(15, 120) if status == 'delayed' else None

            Flight.objects.get_or_create(
                flight_number=f_data['flight_number'],
                airline=airline,
                departure_airport=dep_airport,
                arrival_airport=arr_airport,
                defaults={
                    'departure_time': dep_time,
                    'arrival_time': arr_time,
                    'terminal': random.choice(TERMINALS),
                    'gate': random.choice(GATES),
                    'status': status,
                    'aircraft': f_data['aircraft'],
                    'delay_minutes': delay,
                    'boarding_group': None if status == 'cancelled' else random.choice(['A', 'B', 'C', 'D', 'E']),
                    'baggage_claim': None if status in ('scheduled', 'boarding', 'departed', 'cancelled') else random.choice(['1', '2', '3', '4', '5']),
                }
            )

    @classmethod
    def get_live_feed(cls):
        cls.seed()
        flights = Flight.objects.select_related('airline', 'departure_airport', 'arrival_airport').all()[:30]

        feed = []
        for flight in flights:
            simulated = cls._simulate_update(flight)
            feed.append(simulated)

        return feed

    @classmethod
    def _simulate_update(cls, flight):
        roll = random.random()
        update = {
            'id': str(flight.id),
            'flight_number': flight.flight_number,
            'airline': {
                'code': flight.airline.code,
                'name': flight.airline.name,
                'logo_url': flight.airline.logo_url,
            },
            'departure_airport': {
                'code': flight.departure_airport.code,
                'city': flight.departure_airport.city,
                'name': flight.departure_airport.name,
            },
            'arrival_airport': {
                'code': flight.arrival_airport.code,
                'city': flight.arrival_airport.city,
                'name': flight.arrival_airport.name,
            },
            'departure_time': flight.departure_time.isoformat(),
            'arrival_time': flight.arrival_time.isoformat(),
            'terminal': flight.terminal,
            'gate': flight.gate,
            'status': flight.status,
            'aircraft': flight.aircraft,
            'delay_minutes': flight.delay_minutes,
            'boarding_group': flight.boarding_group,
            'baggage_claim': flight.baggage_claim,
            'last_updated': timezone.now().isoformat(),
        }

        if roll < 0.05:
            new_status = random.choice(['delayed', 'boarding', 'departed'])
            old_status = flight.status
            if new_status != old_status:
                update['status'] = new_status
                update['simulated_change'] = f'Status changed from {old_status} to {new_status}'

        if 0.05 <= roll < 0.08:
            new_gate = random.choice(GATES)
            update['gate'] = new_gate
            update['simulated_change'] = f'Gate changed to {new_gate}'

        if 0.08 <= roll < 0.10:
            extra_delay = random.randint(10, 60)
            update['delay_minutes'] = (flight.delay_minutes or 0) + extra_delay
            update['simulated_change'] = f'Delayed by {extra_delay} more minutes'

        return update
