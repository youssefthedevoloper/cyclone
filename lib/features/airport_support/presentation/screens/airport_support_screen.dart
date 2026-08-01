import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'package:cyclone/core/theme/app_colors.dart';
import 'package:cyclone/core/constants/app_constants.dart';
import 'package:cyclone/widgets/cyclone_card.dart';
import 'package:cyclone/widgets/pressable.dart';

class AirportSupportScreen extends StatefulWidget {
  const AirportSupportScreen({super.key});

  @override
  State<AirportSupportScreen> createState() => _AirportSupportScreenState();
}

class _AirportSupportScreenState extends State<AirportSupportScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _chatController = TextEditingController();
  final ScrollController _chatScrollController = ScrollController();
  
  final List<_ChatMessage> _messages = [
    _ChatMessage(
      text: "Hello! I'm your Airport Support Assistant. How can I help you today?",
      isBot: true,
      timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
    ),
  ];

  final List<_FAQ> _faqs = [
    _FAQ(
      question: 'How do I find my departure gate?',
      answer: 'Check your boarding pass or the departure screens located throughout the terminal. Gates are organized by terminal sections (A, B, C). Follow the directional signs overhead.',
      category: 'Navigation',
    ),
    _FAQ(
      question: 'What items are allowed in carry-on luggage?',
      answer: 'Liquids must be in containers of 100ml or less and fit in a clear plastic bag. Electronics larger than a phone should be removed for screening. No sharp objects or weapons are permitted.',
      category: 'Security',
    ),
    _FAQ(
      question: 'How early should I arrive for my flight?',
      answer: 'Domestic flights: 2 hours before departure\nInternational flights: 3 hours before departure\nPeak travel times may require additional time.',
      category: 'Check-in',
    ),
    _FAQ(
      question: 'Where can I find free WiFi?',
      answer: 'Connect to "JFK_FREE_WIFI" network. No password required. Premium WiFi is available for purchase for faster speeds.',
      category: 'Services',
    ),
    _FAQ(
      question: 'What if my flight is delayed or cancelled?',
      answer: 'Check with your airline immediately. They will rebook you on the next available flight. For long delays, airlines may provide meal vouchers or hotel accommodation.',
      category: 'Flight Issues',
    ),
    _FAQ(
      question: 'Where are the restrooms and baby changing facilities?',
      answer: 'Restrooms are located near all gate areas and main corridors. Family restrooms with changing tables are available in each terminal section.',
      category: 'Facilities',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _chatController.dispose();
    _chatScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Header with gradient
          SliverAppBar(
            expandedHeight: 140,
            floating: false,
            pinned: true,
            elevation: 0,
            backgroundColor: Colors.transparent,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: AppColors.purpleGradient,
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const SizedBox(height: 20),
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
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Airport Support',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 24,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: -0.5,
                                    ),
                                  ),
                                  Text(
                                    'We\'re here to help 24/7',
                                    style: TextStyle(
                                      color: Colors.white.withValues(alpha: 0.8),
                                      fontSize: 14,
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
                                Icons.support_agent,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
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
                    gradient: AppColors.purpleGradient,
                    borderRadius: BorderRadius.circular(23),
                  ),
                  indicatorSize: TabBarIndicatorSize.tab,
                  labelStyle: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                  unselectedLabelStyle: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                  labelColor: Colors.white,
                  unselectedLabelColor: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.textSecondary,
                  dividerColor: Colors.transparent,
                  tabs: const [
                    Tab(
                      icon: Icon(Icons.chat_bubble_outline, size: 18),
                      text: 'Live Chat',
                    ),
                    Tab(
                      icon: Icon(Icons.help_outline, size: 18),
                      text: 'FAQ',
                    ),
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
                _buildChatTab(),
                _buildFAQTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatTab() {
    return Column(
      children: [
        // Quick Actions
        Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Quick Actions',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _QuickActionCard(
                      icon: Icons.phone_outlined,
                      title: 'Call Support',
                      subtitle: 'Direct line',
                      gradient: AppColors.greenGradient,
                      onTap: () => _handleQuickAction('call'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _QuickActionCard(
                      icon: Icons.location_on_outlined,
                      title: 'Find Help Desk',
                      subtitle: 'Terminal map',
                      gradient: AppColors.tealGradient,
                      onTap: () => _handleQuickAction('location'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        
        // Chat Messages
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ListView.builder(
              controller: _chatScrollController,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return _ChatBubble(message: message)
                    .animate(delay: (50 * index).ms)
                    .fadeIn()
                    .slideY(begin: 0.05);
              },
            ),
          ),
        ),
        
        // Chat Input
        _buildChatInput(),
      ],
    );
  }

  Widget _buildFAQTab() {
    final groupedFAQs = <String, List<_FAQ>>{};
    for (final faq in _faqs) {
      groupedFAQs.putIfAbsent(faq.category, () => []).add(faq);
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Frequently Asked Questions',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: groupedFAQs.length,
              itemBuilder: (context, index) {
                final entry = groupedFAQs.entries.elementAt(index);
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (index > 0) const SizedBox(height: 24),
                    _FAQCategory(
                      category: entry.key,
                      faqs: entry.value,
                    ).animate(delay: (100 * index).ms).fadeIn().slideY(begin: 0.05),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatInput() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.surface,
        border: Border(
          top: BorderSide(
            color: isDark ? AppColors.darkBorder : AppColors.border,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkBackground : AppColors.background,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: isDark ? AppColors.darkBorder : AppColors.border,
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                controller: _chatController,
                decoration: const InputDecoration(
                  hintText: 'Type your question...',
                  border: InputBorder.none,
                ),
                onSubmitted: (_) => _sendMessage(),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Pressable(
            onTap: _sendMessage,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: AppColors.purpleGradient,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.send,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _sendMessage() {
    final text = _chatController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add(_ChatMessage(
        text: text,
        isBot: false,
        timestamp: DateTime.now(),
      ));
    });
    
    _chatController.clear();
    _scrollToBottom();

    // Simulate bot response
    Future.delayed(const Duration(milliseconds: 800), () {
      if (!mounted) return;
      setState(() {
        _messages.add(_ChatMessage(
          text: _generateBotResponse(text),
          isBot: true,
          timestamp: DateTime.now(),
        ));
      });
      _scrollToBottom();
    });
  }

  String _generateBotResponse(String input) {
    final lower = input.toLowerCase();
    
    if (lower.contains('gate') || lower.contains('boarding')) {
      return "To find your gate, check your boarding pass or look at the departure monitors. Follow the overhead signs to your terminal section. Need directions to a specific gate?";
    } else if (lower.contains('security') || lower.contains('checkpoint')) {
      return "Security checkpoints open at 4:30 AM. Current wait time is about 15-20 minutes. Remember: liquids in 100ml containers, remove electronics larger than a phone.";
    } else if (lower.contains('wifi') || lower.contains('internet')) {
      return "Free WiFi: Connect to 'JFK_FREE_WIFI' - no password needed. For faster speeds, premium WiFi is available for purchase.";
    } else if (lower.contains('food') || lower.contains('restaurant')) {
      return "Great dining options available! Try Shake Shack near Gate B23, or Starbucks at Gate B28. Would you like directions to a specific restaurant?";
    } else if (lower.contains('delayed') || lower.contains('cancelled')) {
      return "I'm sorry about the flight disruption. Please contact your airline directly for rebooking. For long delays, they may provide meal vouchers or accommodation.";
    } else if (lower.contains('lost') || lower.contains('baggage')) {
      return "For lost baggage, visit your airline's baggage service office with your claim ticket. You can also track your bag via your airline's app.";
    }
    
    return "I understand your question about '$input'. Let me connect you with a human agent who can provide detailed assistance. In the meantime, you can also check our FAQ section for common questions.";
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_chatScrollController.hasClients) {
        _chatScrollController.animateTo(
          _chatScrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _handleQuickAction(String action) {
    switch (action) {
      case 'call':
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Calling Airport Support: +1-555-AIRPORT'),
            backgroundColor: AppColors.success,
          ),
        );
        break;
      case 'location':
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Opening map to nearest help desk...'),
          ),
        );
        break;
    }
  }
}

// ─── Quick Action Card ──────────────────────────────────────────────────────

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
              size: 24,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
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

// ─── Chat Bubble ────────────────────────────────────────────────────────────

class _ChatBubble extends StatelessWidget {
  const _ChatBubble({required this.message});

  final _ChatMessage message;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: message.isBot ? MainAxisAlignment.start : MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (message.isBot) ...[
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                gradient: AppColors.purpleGradient,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.support_agent,
                color: Colors.white,
                size: 14,
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                gradient: message.isBot ? null : AppColors.purpleGradient,
                color: message.isBot
                    ? (isDark ? AppColors.darkSurface : AppColors.surface)
                    : null,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(20),
                  topRight: const Radius.circular(20),
                  bottomLeft: Radius.circular(message.isBot ? 4 : 20),
                  bottomRight: Radius.circular(message.isBot ? 20 : 4),
                ),
                border: message.isBot
                    ? Border.all(
                        color: isDark
                            ? AppColors.darkBorder.withValues(alpha: 0.5)
                            : AppColors.border)
                    : null,
              ),
              child: Text(
                message.text,
                style: TextStyle(
                  color: message.isBot
                      ? (isDark ? AppColors.darkTextPrimary : AppColors.textPrimary)
                      : Colors.white,
                  fontSize: 14,
                  height: 1.4,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── FAQ Category ───────────────────────────────────────────────────────────

class _FAQCategory extends StatelessWidget {
  const _FAQCategory({
    required this.category,
    required this.faqs,
  });

  final String category;
  final List<_FAQ> faqs;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          category,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 8),
        CycloneCard(
          padding: EdgeInsets.zero,
          child: Column(
            children: faqs.asMap().entries.map((entry) {
              final index = entry.key;
              final faq = entry.value;
              return Column(
                children: [
                  _FAQItem(faq: faq),
                  if (index < faqs.length - 1)
                    Divider(
                      height: 1,
                      color: Theme.of(context).dividerColor.withValues(alpha: 0.3),
                    ),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class _FAQItem extends StatefulWidget {
  const _FAQItem({required this.faq});

  final _FAQ faq;

  @override
  State<_FAQItem> createState() => _FAQItemState();
}

class _FAQItemState extends State<_FAQItem> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Pressable(
      onTap: () => setState(() => _isExpanded = !_isExpanded),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    widget.faq.question,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                AnimatedRotation(
                  turns: _isExpanded ? 0.5 : 0,
                  duration: const Duration(milliseconds: 200),
                  child: Icon(
                    Icons.keyboard_arrow_down,
                    color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                  ),
                ),
              ],
            ),
            AnimatedCrossFade(
              firstChild: const SizedBox.shrink(),
              secondChild: Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Text(
                  widget.faq.answer,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                    height: 1.5,
                  ),
                ),
              ),
              crossFadeState: _isExpanded
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              duration: const Duration(milliseconds: 200),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Data Models ────────────────────────────────────────────────────────────

class _ChatMessage {
  const _ChatMessage({
    required this.text,
    required this.isBot,
    required this.timestamp,
  });

  final String text;
  final bool isBot;
  final DateTime timestamp;
}

class _FAQ {
  const _FAQ({
    required this.question,
    required this.answer,
    required this.category,
  });

  final String question;
  final String answer;
  final String category;
}

