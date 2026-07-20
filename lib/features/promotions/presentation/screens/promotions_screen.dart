import 'package:flutter/material.dart';

import 'package:cyclone/core/constants/app_constants.dart';
import 'package:cyclone/core/theme/app_colors.dart';
import 'package:cyclone/widgets/cyclone_card.dart';
import 'package:cyclone/widgets/gradient_button.dart';

class PromotionsScreen extends StatefulWidget {
  const PromotionsScreen({super.key, this.embedded = false});

  final bool embedded;

  @override
  State<PromotionsScreen> createState() => _PromotionsScreenState();
}

class _PromotionsScreenState extends State<PromotionsScreen> {
  final _qrController = TextEditingController();
  String _status = 'Ready';

  @override
  void dispose() {
    _qrController.dispose();
    super.dispose();
  }

  void _scanCoupon() {
    final code = _qrController.text.trim();
    if (code.isEmpty) {
      setState(() => _status = 'Enter a coupon QR token first.');
      return;
    }

    setState(() => _status = 'Coupon applied: $code');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Promotion coupon applied (demo): $code')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final body = Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Promotions',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          Text(
            'Pick a category or scan a QR coupon for discounts inside the terminal.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: AppConstants.spacingLg),
          _ActionGrid(
            actions: [
              _ActionTile(
                icon: Icons.restaurant_outlined,
                title: 'Restaurants',
                onTap: () => _setStatus('Restaurant offers opened (demo).'),
              ),
              _ActionTile(
                icon: Icons.shopping_bag_outlined,
                title: 'Duty Free',
                onTap: () => _setStatus('Duty Free offers opened (demo).'),
              ),
              _ActionTile(
                icon: Icons.local_cafe_outlined,
                title: 'Coffee Shops',
                onTap: () => _setStatus('Coffee offers opened (demo).'),
              ),
              _ActionTile(
                icon: Icons.local_offer_outlined,
                title: 'Promo Codes',
                onTap: () => _setStatus('Promo codes opened (demo).'),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spacingLg),
          CycloneCard(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Scan QR Coupon', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                Text(
                  'Paste coupon token to simulate scan. Example: PROMO-22%OFF',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _qrController,
                  decoration: const InputDecoration(
                    labelText: 'Coupon QR token',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                GradientButton(
                  label: 'Apply Coupon',
                  icon: Icons.qr_code,
                  onPressed: _scanCoupon,
                ),
                const SizedBox(height: 12),
                Text('Status: $_status', style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
          ),
        ],
      ),
    );

    if (widget.embedded) return body;

    return Scaffold(
      appBar: AppBar(title: const Text('Promotions')),
      body: SafeArea(child: SingleChildScrollView(child: body)),
    );
  }

  void _setStatus(String s) {
    setState(() => _status = s);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(s)));
  }
}

class _ActionGrid extends StatelessWidget {
  const _ActionGrid({required this.actions});
  final List<_ActionTile> actions;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      childAspectRatio: 1.2,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      children: actions.map((a) => a).toList(),
    );
  }
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({required this.icon, required this.title, required this.onTap});

  final IconData icon;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: CycloneCard(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: AppColors.primary),
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w700),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

