import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'package:cyclone/core/constants/app_constants.dart';
import 'package:cyclone/core/theme/app_colors.dart';
import 'package:cyclone/widgets/cyclone_card.dart';
import 'package:cyclone/widgets/pressable.dart';

class PromotionsScreen extends StatefulWidget {
  const PromotionsScreen({super.key, this.embedded = false});

  final bool embedded;

  @override
  State<PromotionsScreen> createState() => _PromotionsScreenState();
}

class _PromotionsScreenState extends State<PromotionsScreen> {
  final PageController _couponController = PageController();
  final TextEditingController _qrController = TextEditingController();
  String _status = 'Ready';

  final List<_Coupon> _featuredCoupons = [
    _Coupon(
      title: '22% OFF',
      subtitle: 'All Restaurant Meals',
      description: 'Valid until tonight at participating restaurants',
      gradient: AppColors.promotionsGradient,
      code: 'FOOD22',
    ),
    _Coupon(
      title: 'Buy 2 Get 1',
      subtitle: 'Duty Free Shopping',
      description: 'On selected cosmetics and fragrances',
      gradient: AppColors.purpleGradient,
      code: 'SHOP21',
    ),
    _Coupon(
      title: '₹500 OFF',
      subtitle: 'Airport Lounge Access',
      description: 'Premium lounge experience with complimentary drinks',
      gradient: AppColors.tealGradient,
      code: 'LOUNGE500',
    ),
  ];

  @override
  void dispose() {
    _couponController.dispose();
    _qrController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    
    final body = CustomScrollView(
      slivers: [
        // Header
        SliverAppBar(
          expandedHeight: 200,
          floating: false,
          pinned: true,
          elevation: 0,
          backgroundColor: Colors.transparent,
          flexibleSpace: FlexibleSpaceBar(
            background: Container(
              decoration: BoxDecoration(
                gradient: AppColors.promotionsGradient,
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.bottomCenter,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const SizedBox(height: 20),
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
                          'Promotions & Offers',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Exclusive deals and discounts at the airport',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.9),
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),

        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              // Featured Coupons Carousel
              _SectionHeader(title: 'Featured Deals'),
              const SizedBox(height: 16),
              _FeaturedCouponsCarousel(
                coupons: _featuredCoupons,
                controller: _couponController,
                onCouponTap: _applyCoupon,
              ),
              const SizedBox(height: 24),

              // Categories Grid
              _SectionHeader(title: 'Browse by Category'),
              const SizedBox(height: 16),
              _CategoriesGrid(),
              const SizedBox(height: 24),

              // QR Scanner Section
              _SectionHeader(title: 'Have a Coupon Code?'),
              const SizedBox(height: 16),
              _QRScannerSection(
                controller: _qrController,
                status: _status,
                onScan: _scanCoupon,
              ),
            ]),
          ),
        ),
      ],
    );

    if (widget.embedded) return body;
    return Scaffold(body: body);
  }

  void _applyCoupon(_Coupon coupon) {
    setState(() => _status = 'Applied: ${coupon.code} - ${coupon.title}');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${coupon.title} coupon applied successfully!'),
        backgroundColor: AppColors.success,
      ),
    );
  }

  void _scanCoupon() {
    final code = _qrController.text.trim();
    if (code.isEmpty) {
      setState(() => _status = 'Enter a coupon code first');
      return;
    }

    setState(() => _status = 'Applied: $code');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Coupon "$code" applied successfully!'),
        backgroundColor: AppColors.success,
      ),
    );
    _qrController.clear();
  }
}

// ─── Section Header ─────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

// ─── Featured Coupons Carousel ──────────────────────────────────────────────

class _FeaturedCouponsCarousel extends StatelessWidget {
  const _FeaturedCouponsCarousel({
    required this.coupons,
    required this.controller,
    required this.onCouponTap,
  });

  final List<_Coupon> coupons;
  final PageController controller;
  final Function(_Coupon) onCouponTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 180,
          child: PageView.builder(
            controller: controller,
            itemCount: coupons.length,
            itemBuilder: (context, index) {
              final coupon = coupons[index];
              return Padding(
                padding: const EdgeInsets.only(right: 16),
                child: _CouponCard(
                  coupon: coupon,
                  onTap: () => onCouponTap(coupon),
                ),
              ).animate(delay: (100 * index).ms).fadeIn().slideX(begin: 0.05);
            },
          ),
        ),
        const SizedBox(height: 16),
        SmoothPageIndicator(
          controller: controller,
          count: coupons.length,
          effect: WormEffect(
            dotWidth: 8,
            dotHeight: 8,
            activeDotColor: AppColors.promotionsGradient.colors.first,
            dotColor: AppColors.promotionsGradient.colors.first.withValues(alpha: 0.3),
            spacing: 6,
          ),
        ),
      ],
    );
  }
}

class _CouponCard extends StatelessWidget {
  const _CouponCard({
    required this.coupon,
    required this.onTap,
  });

  final _Coupon coupon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Pressable(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: coupon.gradient,
          borderRadius: BorderRadius.circular(AppConstants.cardRadius),
          boxShadow: [
            BoxShadow(
              color: coupon.gradient.colors.first.withValues(alpha: 0.3),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Background pattern
            Positioned(
              top: -20,
              right: -20,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.1),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              coupon.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.w800,
                                letterSpacing: -0.5,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              coupon.subtitle,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.9),
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.local_offer,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    coupon.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.85),
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          'Code: ${coupon.code}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Categories Grid ────────────────────────────────────────────────────────

class _CategoriesGrid extends StatelessWidget {
  final List<_Category> _categories = [
    _Category(
      icon: Icons.restaurant_outlined,
      title: 'Dining',
      subtitle: '15+ offers',
      gradient: AppColors.orangeGradient,
    ),
    _Category(
      icon: Icons.shopping_bag_outlined,
      title: 'Duty Free',
      subtitle: '25+ deals',
      gradient: AppColors.purpleGradient,
    ),
    _Category(
      icon: Icons.local_cafe_outlined,
      title: 'Coffee & Snacks',
      subtitle: '8+ offers',
      gradient: AppColors.amberGradient,
    ),
    _Category(
      icon: Icons.flight_outlined,
      title: 'Lounges',
      subtitle: '5+ access deals',
      gradient: AppColors.tealGradient,
    ),
    _Category(
      icon: Icons.spa_outlined,
      title: 'Wellness',
      subtitle: '12+ services',
      gradient: AppColors.greenGradient,
    ),
    _Category(
      icon: Icons.business_outlined,
      title: 'Business',
      subtitle: '6+ offers',
      gradient: AppColors.translatorGradient,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.95,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: _categories.length,
      itemBuilder: (context, index) {
        final category = _categories[index];
        return _CategoryCard(
          category: category,
          onTap: () => _handleCategoryTap(context, category),
        ).animate(delay: (50 * index).ms).fadeIn().slideY(begin: 0.05);
      },
    );
  }

  void _handleCategoryTap(BuildContext context, _Category category) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${category.title} promotions opened!'),
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  const _CategoryCard({
    required this.category,
    required this.onTap,
  });

  final _Category category;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Pressable(
      onTap: onTap,
      child: CycloneCard(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: category.gradient,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: category.gradient.colors.first.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(
                category.icon,
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              category.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              category.subtitle,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// ─── QR Scanner Section ─────────────────────────────────────────────────────

class _QRScannerSection extends StatelessWidget {
  const _QRScannerSection({
    required this.controller,
    required this.status,
    required this.onScan,
  });

  final TextEditingController controller;
  final String status;
  final VoidCallback onScan;

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
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: AppColors.aiGradient,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.qr_code_scanner,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Scan QR Coupon',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Enter coupon code to apply discount',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkBackground : AppColors.background,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isDark ? AppColors.darkBorder : AppColors.border,
              ),
            ),
            child: TextField(
              controller: controller,
              decoration: const InputDecoration(
                hintText: 'Enter coupon code (e.g., FOOD22)',
                prefixIcon: Icon(Icons.confirmation_number_outlined),
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(16),
              ),
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => onScan(),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: Pressable(
              onTap: onScan,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  gradient: AppColors.promotionsGradient,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.redeem, color: Colors.white, size: 20),
                    SizedBox(width: 8),
                    Text(
                      'Apply Coupon',
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
          if (status != 'Ready') ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.success.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppColors.success.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.check_circle_outline,
                    color: AppColors.success,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      status,
                      style: TextStyle(
                        color: AppColors.success,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    ).animate().fadeIn(delay: 300.ms);
  }
}

// ─── Data Models ────────────────────────────────────────────────────────────

class _Coupon {
  const _Coupon({
    required this.title,
    required this.subtitle,
    required this.description,
    required this.gradient,
    required this.code,
  });

  final String title;
  final String subtitle;
  final String description;
  final LinearGradient gradient;
  final String code;
}

class _Category {
  const _Category({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.gradient,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final LinearGradient gradient;
}

