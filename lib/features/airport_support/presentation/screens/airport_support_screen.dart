import 'package:flutter/material.dart';

import 'package:cyclone/core/theme/app_colors.dart';
import 'package:cyclone/widgets/cyclone_card.dart';
import 'package:cyclone/widgets/gradient_button.dart';

class AirportSupportScreen extends StatelessWidget {
  const AirportSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Airport Support')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ListView(
            children: [
              CycloneCard(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Need help?',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Contact support, scan QR tickets, or open quick help flows.',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        _SupportChip(
                          icon: Icons.support_agent_outlined,
                          label: 'Help Desk',
                          onTap: () => _notify(context, 'Help Desk opened (demo).'),
                        ),
                        _SupportChip(
                          icon: Icons.phone_outlined,
                          label: 'Call',
                          onTap: () => _notify(context, 'Calling Airport Support (demo).'),
                        ),
                        _SupportChip(
                          icon: Icons.chat_bubble_outline,
                          label: 'Messages',
                          onTap: () => _notify(context, 'Messages opened (demo).'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    GradientButton(
                      label: 'Open Support QR Flow',
                      icon: Icons.qr_code,
                      onPressed: () => _notify(context, 'Support QR flow opened (demo).'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              CycloneCard(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Quick Topics', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
                    const SizedBox(height: 12),
                    ...[
                      _TopicRow(Icons.flight_takeoff, 'Boarding changes'),
                      _TopicRow(Icons.security, 'Security guidance'),
                      _TopicRow(Icons.local_hospital_outlined, 'Medical help'),
                      _TopicRow(Icons.directions_bus, 'Transport & parking'),
                    ].map((e) => Padding(padding: const EdgeInsets.only(bottom: 10), child: e)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _notify(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }
}

class _SupportChip extends StatelessWidget {
  const _SupportChip({required this.icon, required this.label, required this.onTap});

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: CycloneCard(
        padding: const EdgeInsets.all(12),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: AppColors.primary),
            ),
            const SizedBox(width: 10),
            Text(label, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800)),
          ],
        ),
      ),
    );
  }
}

class _TopicRow extends StatelessWidget {
  const _TopicRow(this.icon, this.title);

  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
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
          child: Text(title, style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w700)),
        ),
        const Icon(Icons.chevron_right, color: AppColors.textTertiary),
      ],
    );
  }
}

