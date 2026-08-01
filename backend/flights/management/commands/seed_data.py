from datetime import timedelta

from django.core.management.base import BaseCommand
from flights.demo import DemoFlightEngine
from promotions.models import Promotion
from rewards.models import Achievement


class Command(BaseCommand):
    help = 'Seed the database with initial data'

    def handle(self, *args, **options):
        self.stdout.write('Seeding flights...')
        DemoFlightEngine.seed()
        self.stdout.write(self.style.SUCCESS(f'  Flights seeded'))

        self.stdout.write('Seeding promotions...')
        from django.utils import timezone
        now = timezone.now()
        promos = [
            Promotion(code='WELCOME20', title='Welcome Discount', description='20% off your first purchase',
                      discount_percent=20, category='restaurant', is_active=True,
                      start_date=now, end_date=now + timedelta(days=90)),
            Promotion(code='DUTYFREE10', title='Duty Free Savings', description='10% off duty free purchases',
                      discount_percent=10, category='duty_free', is_active=True,
                      start_date=now, end_date=now + timedelta(days=60)),
            Promotion(code='LOUNGE15', title='Lounge Access', description='15% off lounge pass',
                      discount_percent=15, category='service', is_active=True,
                      start_date=now, end_date=now + timedelta(days=30)),
            Promotion(code='TAXI5', title='Taxi Discount', description='$5 off airport taxi',
                      discount_amount=5, category='taxi', is_active=True,
                      start_date=now, end_date=now + timedelta(days=45)),
            Promotion(code='HOTEL20', title='Hotel Deal', description='20% off airport hotels',
                      discount_percent=20, category='hotel', is_active=True,
                      start_date=now, end_date=now + timedelta(days=120)),
        ]
        for p in promos:
            p.save()
        self.stdout.write(self.style.SUCCESS(f'  {len(promos)} promotions created'))

        self.stdout.write('Seeding achievements...')
        achievements = [
            Achievement(code='first_flight', name='First Flight', description='Track your first flight', xp_reward=100),
            Achievement(code='jet_setter', name='Jet Setter', description='Complete 5 flights', xp_reward=500),
            Achievement(code='globetrotter', name='Globetrotter', description='Visit 10 different airports', xp_reward=1000),
            Achievement(code='early_bird', name='Early Bird', description='Check in 24h before 3 flights', xp_reward=300),
            Achievement(code='loyal_traveler', name='Loyal Traveler', description='Use Cyclone for 30 days', xp_reward=2000),
        ]
        for a in achievements:
            a.save()
        self.stdout.write(self.style.SUCCESS(f'  {len(achievements)} achievements created'))
        self.stdout.write(self.style.SUCCESS('Database seeding complete!'))
