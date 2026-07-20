import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:cyclone/core/theme/app_colors.dart';
import 'package:cyclone/widgets/cyclone_card.dart';

class ServicesScreen extends StatelessWidget {
  const ServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Services',
                      style: Theme.of(context).textTheme.displayMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Premium tools for your journey.',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.only(bottom: 16),
                sliver: SliverGrid.builder(
                  itemCount: 6,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 1.05,
                  ),
                  itemBuilder: (context, index) {
                    final items = [
                      _ServiceTile(
                        title: 'AI Assistant',
                        icon: Icons.smart_toy_outlined,
                        onTap: () => context.push('/assistant'),
                      ),
                      _ServiceTile(
                        title: 'Translator',
                        icon: Icons.translate_outlined,
                        onTap: () => context.push('/assistant/translator'),
                      ),
                      _ServiceTile(
                        title: 'Lost & Found',
                        icon: Icons.qr_code_scanner_outlined,
                        onTap: () => context.push('/lost-and-found'),
                      ),
                      _ServiceTile(
                        title: 'Notifications',
                        icon: Icons.notifications_outlined,
                        onTap: () => context.push('/notifications'),
                      ),
                      _ServiceTile(
                        title: 'Accessibility',
                        icon: Icons.accessibility_new_outlined,
                        onTap: () => context.push('/accessibility'),
                      ),
                      _ServiceTile(
                        title: 'Airport Support',
                        icon: Icons.support_agent_outlined,
                        onTap: () => context.push('/airport-support'),
                      ),
                    ];

                    final item = items[index];

                    return CycloneCard(
                      onTap: item.onTap,
                      child: Padding(
                        padding: const EdgeInsets.all(14),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Icon(item.icon,
                                  color: AppColors.primary, size: 22),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              item.title,
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w700,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ServiceTile {
  const _ServiceTile({
    required this.title,
    required this.icon,
    required this.onTap,
  });

  final String title;
  final IconData icon;
  final VoidCallback onTap;
}

