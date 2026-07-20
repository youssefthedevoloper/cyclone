import 'package:flutter/material.dart';

import 'package:cyclone/core/theme/app_colors.dart';
import 'package:cyclone/widgets/cyclone_card.dart';

import 'package:cyclone/features/translator/presentation/screens/translator_screen.dart';
import 'package:cyclone/features/lost_found/presentation/screens/lost_and_found_screen.dart';
import 'package:cyclone/features/promotions/presentation/screens/promotions_screen.dart';

class AiAssistantScreen extends StatelessWidget {
  const AiAssistantScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Assistant'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _SectionIntro(
              icon: Icons.auto_awesome_outlined,
              title: 'Translator',
              subtitle: 'Speak and translate in real-time (UI-first demo).',
              child: const TranslatorScreen(),
            ),
            const SizedBox(height: 16),
            _SectionIntro(
              icon: Icons.qr_code_scanner,
              title: 'Lost & Found',
              subtitle: 'Report, claim and track items with QR flow.',
              child: const LostAndFoundScreen(embedded: true),
            ),
            const SizedBox(height: 16),
            _SectionIntro(
              icon: Icons.local_offer_outlined,
              title: 'Promotions',
              subtitle: 'Restaurants, Duty Free, Coffee Shops & QR coupons.',
              child: const PromotionsScreen(embedded: true),
            ),
            const SizedBox(height: 24),
            Text(
              'Tip: Use the Services menu on Home to access each module full-screen.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionIntro extends StatelessWidget {
  const _SectionIntro({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.child,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return CycloneCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: AppColors.primary),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}

