import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'package:cyclone/core/constants/app_constants.dart';
import 'package:cyclone/core/theme/app_colors.dart';
import 'package:cyclone/widgets/cyclone_card.dart';
import 'package:cyclone/widgets/pressable.dart';

class LostAndFoundScreen extends StatefulWidget {
  const LostAndFoundScreen({super.key, this.embedded = false});

  final bool embedded;

  @override
  State<LostAndFoundScreen> createState() => _LostAndFoundScreenState();
}

class _LostAndFoundScreenState extends State<LostAndFoundScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _trackingController = TextEditingController();
  
  // Mock tracking data
  final List<_TrackingItem> _trackingItems = [
    _TrackingItem(
      id: 'LF-83912',
      type: 'Lost',
      item: 'Black Laptop Bag',
      location: 'Security Checkpoint B',
      status: _TrackingStatus.found,
      lastUpdate: DateTime.now().subtract(const Duration(hours: 2)),
      description: 'Black leather laptop bag with company logo',
    ),
    _TrackingItem(
      id: 'LF-83913',
      type: 'Lost',
      item: 'Blue Umbrella',
      location: 'Gate A15',
      status: _TrackingStatus.searching,
      lastUpdate: DateTime.now().subtract(const Duration(hours: 6)),
      description: 'Blue collapsible umbrella, automatic open/close',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _trackingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    final body = CustomScrollView(
      slivers: [
        // Header
        SliverAppBar(
          expandedHeight: 160,
          floating: false,
          pinned: true,
          elevation: 0,
          backgroundColor: Colors.transparent,
          flexibleSpace: FlexibleSpaceBar(
            background: Container(
              decoration: BoxDecoration(
                gradient: AppColors.orangeGradient,
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const SizedBox(height: 12),
                      if (!widget.embedded)
                        Row(
                          children: [
                            Pressable(
                              onTap: () => Navigator.pop(context),
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(
                                  Icons.arrow_back,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                          ],
                        ),
                      const Text(
                        'Lost & Found',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Report, track, and recover lost items',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.9),
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],
                  ),
                ),
              ),
            ),
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(50),
            child: Container(
              margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurface : AppColors.surface,
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color: isDark ? AppColors.darkBorder : AppColors.border,
                ),
              ),
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  gradient: AppColors.orangeGradient,
                  borderRadius: BorderRadius.circular(23),
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                labelStyle: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                ),
                unselectedLabelStyle: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
                labelColor: Colors.white,
                unselectedLabelColor: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.textSecondary,
                dividerColor: Colors.transparent,
                tabs: const [
                  Tab(text: 'Report Item'),
                  Tab(text: 'Track Status'),
                  Tab(text: 'Found Items'),
                ],
              ),
            ),
          ),
        ),

        // Content
        SliverFillRemaining(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildReportTab(),
              _buildTrackingTab(),
              _buildFoundItemsTab(),
            ],
          ),
        ),
      ],
    );

    if (widget.embedded) return body;
    return Scaffold(body: body);
  }

  Widget _buildReportTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Quick Actions
          _QuickActionsSection(),
          const SizedBox(height: 24),
          
          // Report Form
          _ReportFormSection(),
        ],
      ),
    );
  }

  Widget _buildTrackingTab() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tracking Search
          _TrackingSearchSection(
            controller: _trackingController,
            onSearch: _searchTracking,
          ),
          const SizedBox(height: 20),
          
          // Tracking Results
          const Text(
            'Your Reports',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          
          Expanded(
            child: ListView.builder(
              itemCount: _trackingItems.length,
              itemBuilder: (context, index) {
                final item = _trackingItems[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _TrackingCard(
                    item: item,
                    onTap: () => _showTrackingDetails(item),
                  ).animate(delay: (100 * index).ms).fadeIn().slideX(begin: 0.05),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFoundItemsTab() {
    return const Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          Expanded(
            child: _FoundItemsGrid(),
          ),
        ],
      ),
    );
  }

  void _searchTracking() {
    final query = _trackingController.text.trim();
    if (query.isEmpty) return;
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Searching for: $query')),
    );
  }

  void _showTrackingDetails(_TrackingItem item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _TrackingDetailsSheet(item: item),
    );
  }
}

// ─── Quick Actions Section ──────────────────────────────────────────────────

class _QuickActionsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quick Actions',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _QuickActionCard(
                icon: Icons.report_problem_outlined,
                title: 'Report Lost',
                subtitle: 'Lost an item',
                gradient: AppColors.orangeGradient,
                onTap: () => _showReportDialog(context, 'lost'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _QuickActionCard(
                icon: Icons.inventory_2_outlined,
                title: 'Report Found',
                subtitle: 'Found an item',
                gradient: AppColors.greenGradient,
                onTap: () => _showReportDialog(context, 'found'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _showReportDialog(BuildContext context, String type) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${type == 'lost' ? 'Lost' : 'Found'} item report started'),
        backgroundColor: type == 'lost' ? AppColors.warning : AppColors.success,
      ),
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  const _QuickActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.gradient,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final LinearGradient gradient;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Pressable(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(AppConstants.cardRadius),
          boxShadow: [
            BoxShadow(
              color: gradient.colors.first.withValues(alpha: 0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: 28,
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              subtitle,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.8),
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Report Form Section ────────────────────────────────────────────────────

class _ReportFormSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return CycloneCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: AppColors.orangeGradient,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.edit_outlined,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Report Details',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          
          // Item Category
          Text(
            'Item Category',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          _CategorySelector(),
          const SizedBox(height: 16),
          
          // Description Field
          Text(
            'Description',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkBackground : AppColors.background,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isDark ? AppColors.darkBorder : AppColors.border,
              ),
            ),
            child: const TextField(
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Describe the item (color, brand, size, etc.)',
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(16),
              ),
            ),
          ),
          const SizedBox(height: 16),
          
          // Location Field
          Text(
            'Last Known Location',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkBackground : AppColors.background,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isDark ? AppColors.darkBorder : AppColors.border,
              ),
            ),
            child: const TextField(
              decoration: InputDecoration(
                hintText: 'e.g., Gate A15, Security Checkpoint B',
                prefixIcon: Icon(Icons.location_on_outlined),
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(16),
              ),
            ),
          ),
          const SizedBox(height: 20),
          
          // Submit Button
          SizedBox(
            width: double.infinity,
            child: Pressable(
              onTap: () => _submitReport(context),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  gradient: AppColors.orangeGradient,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.send, color: Colors.white, size: 20),
                    SizedBox(width: 8),
                    Text(
                      'Submit Report',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 200.ms);
  }

  void _submitReport(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Report submitted successfully! Tracking ID: LF-83914'),
        backgroundColor: AppColors.success,
      ),
    );
  }
}

class _CategorySelector extends StatefulWidget {
  @override
  State<_CategorySelector> createState() => _CategorySelectorState();
}

class _CategorySelectorState extends State<_CategorySelector> {
  String _selectedCategory = '';
  
  final List<String> _categories = [
    'Electronics',
    'Clothing',
    'Bags & Luggage',
    'Documents',
    'Jewelry',
    'Other',
  ];

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: _categories.map((category) {
        final isSelected = _selectedCategory == category;
        return Pressable(
          onTap: () => setState(() => _selectedCategory = category),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              gradient: isSelected ? AppColors.orangeGradient : null,
              color: isSelected ? null : AppColors.border.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected ? Colors.transparent : AppColors.border,
              ),
            ),
            child: Text(
              category,
              style: TextStyle(
                color: isSelected ? Colors.white : null,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
// ─── Tracking Search Section ────────────────────────────────────────────────

class _TrackingSearchSection extends StatelessWidget {
  const _TrackingSearchSection({
    required this.controller,
    required this.onSearch,
  });

  final TextEditingController controller;
  final VoidCallback onSearch;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.border,
        ),
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: 'Enter tracking ID (e.g., LF-83912)',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: IconButton(
            onPressed: onSearch,
            icon: const Icon(Icons.track_changes),
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(16),
        ),
        onSubmitted: (_) => onSearch(),
      ),
    );
  }
}

// ─── Tracking Card ──────────────────────────────────────────────────────────

class _TrackingCard extends StatelessWidget {
  const _TrackingCard({
    required this.item,
    required this.onTap,
  });

  final _TrackingItem item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Pressable(
      onTap: onTap,
      child: CycloneCard(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: _getStatusColor(item.status).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    _getStatusIcon(item.status),
                    color: _getStatusColor(item.status),
                    size: 16,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.item,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        'ID: ${item.id}',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getStatusColor(item.status),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _getStatusText(item.status),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(
                  Icons.location_on_outlined,
                  size: 14,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    item.location,
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
                Text(
                  _formatTime(item.lastUpdate),
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(_TrackingStatus status) {
    switch (status) {
      case _TrackingStatus.found:
        return AppColors.success;
      case _TrackingStatus.searching:
        return AppColors.warning;
      case _TrackingStatus.closed:
        return AppColors.error;
    }
  }

  IconData _getStatusIcon(_TrackingStatus status) {
    switch (status) {
      case _TrackingStatus.found:
        return Icons.check_circle;
      case _TrackingStatus.searching:
        return Icons.search;
      case _TrackingStatus.closed:
        return Icons.close;
    }
  }

  String _getStatusText(_TrackingStatus status) {
    switch (status) {
      case _TrackingStatus.found:
        return 'FOUND';
      case _TrackingStatus.searching:
        return 'SEARCHING';
      case _TrackingStatus.closed:
        return 'CLOSED';
    }
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final diff = now.difference(time);
    if (diff.inHours < 1) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }
}

// ─── Found Items Grid ───────────────────────────────────────────────────────

class _FoundItemsGrid extends StatelessWidget {
  const _FoundItemsGrid();

  final List<_FoundItem> _foundItems = const [
    _FoundItem(
      id: 'FI-001',
      item: 'iPhone 13 Pro',
      location: 'Gate B15',
      category: 'Electronics',
      date: 'Today',
    ),
    _FoundItem(
      id: 'FI-002',
      item: 'Blue Scarf',
      location: 'Restroom A3',
      category: 'Clothing',
      date: 'Yesterday',
    ),
    _FoundItem(
      id: 'FI-003',
      item: 'Leather Wallet',
      location: 'Security Check',
      category: 'Personal',
      date: '2 days ago',
    ),
    _FoundItem(
      id: 'FI-004',
      item: 'Reading Glasses',
      location: 'Coffee Shop',
      category: 'Personal',
      date: '3 days ago',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Recently Found Items',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 12),
        Expanded(
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1.1,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: _foundItems.length,
            itemBuilder: (context, index) {
              final item = _foundItems[index];
              return _FoundItemCard(item: item)
                  .animate(delay: (100 * index).ms)
                  .fadeIn()
                  .scale(begin: const Offset(0.8, 0.8));
            },
          ),
        ),
      ],
    );
  }
}

class _FoundItemCard extends StatelessWidget {
  const _FoundItemCard({required this.item});

  final _FoundItem item;

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
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(
                  Icons.inventory_2_outlined,
                  color: AppColors.success,
                  size: 16,
                ),
              ),
              const Spacer(),
              Text(
                item.category,
                style: TextStyle(
                  fontSize: 10,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            item.item,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            item.location,
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
          const Spacer(),
          Row(
            children: [
              Text(
                item.date,
                style: TextStyle(
                  fontSize: 10,
                  color: AppColors.textSecondary,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  item.id,
                  style: TextStyle(
                    fontSize: 9,
                    color: AppColors.success,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Tracking Details Sheet ─────────────────────────────────────────────────

class _TrackingDetailsSheet extends StatelessWidget {
  const _TrackingDetailsSheet({required this.item});

  final _TrackingItem item;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Tracking Details',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _detailRow('Item:', item.item),
              _detailRow('Tracking ID:', item.id),
              _detailRow('Status:', _getStatusText(item.status)),
              _detailRow('Location:', item.location),
              _detailRow('Description:', item.description),
              _detailRow('Last Update:', _formatDateTime(item.lastUpdate)),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Close'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }

  String _getStatusText(_TrackingStatus status) {
    switch (status) {
      case _TrackingStatus.found:
        return 'Found - Ready for pickup';
      case _TrackingStatus.searching:
        return 'Searching - We\'re looking for your item';
      case _TrackingStatus.closed:
        return 'Closed - Case has been closed';
    }
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} at ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}

// ─── Data Models ────────────────────────────────────────────────────────────

enum _TrackingStatus { found, searching, closed }

class _TrackingItem {
  const _TrackingItem({
    required this.id,
    required this.type,
    required this.item,
    required this.location,
    required this.status,
    required this.lastUpdate,
    required this.description,
  });

  final String id;
  final String type;
  final String item;
  final String location;
  final _TrackingStatus status;
  final DateTime lastUpdate;
  final String description;
}

class _FoundItem {
  const _FoundItem({
    required this.id,
    required this.item,
    required this.location,
    required this.category,
    required this.date,
  });

  final String id;
  final String item;
  final String location;
  final String category;
  final String date;
}

