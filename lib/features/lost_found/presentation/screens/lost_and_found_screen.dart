import 'package:flutter/material.dart';

import 'package:cyclone/core/constants/app_constants.dart';
import 'package:cyclone/core/theme/app_colors.dart';
import 'package:cyclone/widgets/cyclone_card.dart';
import 'package:cyclone/widgets/gradient_button.dart';

class LostAndFoundScreen extends StatefulWidget {
  const LostAndFoundScreen({super.key, this.embedded = false});

  final bool embedded;

  @override
  State<LostAndFoundScreen> createState() => _LostAndFoundScreenState();
}

class _LostAndFoundScreenState extends State<LostAndFoundScreen> {
  final _qrController = TextEditingController();
  String _status = 'Ready';

  @override
  void dispose() {
    _qrController.dispose();
    super.dispose();
  }

  void _scanQr() {
    // Since there is no QR scanning plugin wired, implement a stable demo flow.
    // User can paste a request/token.
    final token = _qrController.text.trim();
    if (token.isEmpty) {
      setState(() => _status = 'Enter a QR code token first.');
      return;
    }
    setState(() => _status = 'QR received: $token');

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Lost & Found QR processed (demo): $token')),
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
            'Lost & Found',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          Text(
            'Report lost items, mark found items, track requests, and scan QR for quick lookup.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: AppConstants.spacingLg),
          _ActionGrid(
            actions: [
              _ActionTile(
                icon: Icons.report_problem_outlined,
                title: 'Report Lost Item',
                onTap: () => _setStatus('Lost report started (demo).'),
              ),
              _ActionTile(
                icon: Icons.inventory_2_outlined,
                title: 'Found an Item',
                onTap: () => _setStatus('Found report started (demo).'),
              ),
              _ActionTile(
                icon: Icons.track_changes_outlined,
                title: 'Track Request',
                onTap: () => _setStatus('Tracking request (demo).'),
              ),
              _ActionTile(
                icon: Icons.qr_code_scanner_outlined,
                title: 'Scan QR',
                onTap: () => _setStatus('Scan QR ready.'),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spacingLg),
          CycloneCard(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('QR Lookup', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                Text(
                  'Paste the QR token (for competition demo). Example: LF-83912',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _qrController,
                  decoration: const InputDecoration(
                    labelText: 'QR code token',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                GradientButton(
                  label: 'Scan & Process',
                  icon: Icons.qr_code,
                  onPressed: _scanQr,
                ),
                const SizedBox(height: 12),
                Text('Status: $_status', style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
          ),
        ],
      ),
    );

    if (widget.embedded) {
      return body;
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Lost & Found')),
      body: SafeArea(
        child: SingleChildScrollView(child: body),
      ),
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

