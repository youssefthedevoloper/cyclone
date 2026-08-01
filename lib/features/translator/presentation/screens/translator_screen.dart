import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:cyclone/core/theme/app_colors.dart';
import 'package:cyclone/core/constants/app_constants.dart';
import 'package:cyclone/core/utils/extensions.dart';
import 'package:cyclone/widgets/cyclone_card.dart';
import 'package:cyclone/widgets/gradient_button.dart';
import 'package:cyclone/widgets/pressable.dart';
import 'package:cyclone/features/translator/presentation/providers/translator_provider.dart';

class TranslatorScreen extends ConsumerWidget {
  const TranslatorScreen({super.key, this.embedded = false});

  final bool embedded;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(translatorStateProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final langs = ref.watch(languagesProvider);

    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Language Row
        _LanguageBar(
          sourceLang: state.sourceLang,
          targetLang: state.targetLang,
          langs: langs,
          isDark: isDark,
          onSourceChanged: (v) =>
              ref.read(translatorStateProvider.notifier).setSourceLang(v),
          onTargetChanged: (v) =>
              ref.read(translatorStateProvider.notifier).setTargetLang(v),
          onSwap: () =>
              ref.read(translatorStateProvider.notifier).swapLanguages(),
        ),

        const SizedBox(height: AppConstants.spacingLg),

        // Status row: Auto-translate toggle + Offline indicator + Detected Lang
        _StatusRow(
          autoTranslate: state.autoTranslate,
          isOnline: state.isOnline,
          detectedLang: state.detectedLang,
          sourceLang: state.sourceLang,
          isDark: isDark,
          onToggleAuto: () =>
              ref.read(translatorStateProvider.notifier).toggleAutoTranslate(),
        ),

        const SizedBox(height: AppConstants.spacingLg),

        // Source Input
        _SourcePanel(
          text: state.sourceText ?? '',
          lang: state.sourceLang,
          isListening: state.isListening,
          isDark: isDark,
          onChanged: (v) =>
              ref.read(translatorStateProvider.notifier).onSourceTextChanged(v),
          onMicTap: () =>
              ref.read(translatorStateProvider.notifier).toggleListening(),
        ),

        const SizedBox(height: AppConstants.spacingLg),

        // Translation Output
        _TranslationPanel(
          text: state.translatedText ?? '',
          isLoading: state.isLoading,
          error: state.error,
          targetLang: state.targetLang,
          duration: state.translationDuration,
          isSpeaking: state.isSpeaking,
          isDark: isDark,
          isEmpty: state.translatedText == null || state.translatedText!.isEmpty,
          // Copy/Speak/Share handled below
        ),
        if (state.translatedText != null && state.translatedText!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: AppConstants.spacingMd),
            child: Row(
              children: [
                Expanded(
                  child: _ActionButton(
                    icon: Icons.copy_rounded,
                    label: 'Copy',
                    isDark: isDark,
                    onTap: () => _copyTranslation(context, state.translatedText!),
                  ),
                ),
                const SizedBox(width: AppConstants.spacingSm),
                Expanded(
                  child: _ActionButton(
                    icon: Icons.volume_up_rounded,
                    label: state.isSpeaking ? 'Stop' : 'Listen',
                    isDark: isDark,
                    isActive: state.isSpeaking,
                    onTap: () =>
                        ref.read(translatorStateProvider.notifier).toggleSpeaking(),
                  ),
                ),
                const SizedBox(width: AppConstants.spacingSm),
                Expanded(
                  child: _ActionButton(
                    icon: Icons.share_rounded,
                    label: 'Share',
                    isDark: isDark,
                    onTap: () => _shareTranslation(context, state.translatedText!),
                  ),
                ),
              ],
            ),
          ),

        const SizedBox(height: AppConstants.spacingLg),

        // Translate button
        GradientButton(
          label: 'Translate',
          icon: Icons.translate_rounded,
          isLoading: state.isLoading,
          onPressed: () =>
              ref.read(translatorStateProvider.notifier).translate(),
        ),

        const SizedBox(height: AppConstants.spacingLg),

        // Quick insert for sample phrases
        if (state.sourceText == null || state.sourceText!.isEmpty)
_SamplePhrases(
            isDark: isDark,
            onTap: (phrase) {
              final notifier =
                  ref.read(translatorStateProvider.notifier);
              // We need a way to set source text. Let's add a method.
              notifier.onSourceTextChanged(phrase);
              if (state.autoTranslate) {
                notifier.translate();
              }
            },
          ),

        const SizedBox(height: AppConstants.spacingLg),

        // History & Favorites
        _HistoryFavoritesBar(
          isDark: isDark,
          historyCount: state.history.length,
          favoritesCount: state.favorites.length,
          onHistoryTap: () => _showHistoryDialog(context, ref),
          onFavoritesTap: () => _showFavoritesDialog(context, ref),
        ),
      ],
    );

    if (embedded) return SingleChildScrollView(child: content);

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
      appBar: AppBar(
        backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Translator',
          style: TextStyle(
            color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.5,
          ),
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 120),
          physics: const BouncingScrollPhysics(),
          children: [
            content,
          ],
        ),
      ),
    );
  }

  void _copyTranslation(BuildContext context, String text) async {
    await Clipboard.setData(ClipboardData(text: text));
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Translation copied to clipboard'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppColors.success,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    }
  }

  void _shareTranslation(BuildContext context, String text) async {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Translation ready to share'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppColors.success,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    }
  }

  void _showHistoryDialog(BuildContext context, WidgetRef ref) {
    final state = ref.read(translatorStateProvider);
    showDialog(
      context: context,
      builder: (ctx) => _HistoryDialog(
        records: state.history,
        isDark: Theme.of(context).brightness == Brightness.dark,
        onClear: () =>
            ref.read(translatorStateProvider.notifier).clearHistory(),
      ),
    );
  }

  void _showFavoritesDialog(BuildContext context, WidgetRef ref) {
    final state = ref.read(translatorStateProvider);
    showDialog(
      context: context,
      builder: (ctx) => _FavoritesDialog(
        records: state.favorites,
        isDark: Theme.of(context).brightness == Brightness.dark,
        onClear: () =>
            ref.read(translatorStateProvider.notifier).clearFavorites(),
        onToggleFavorite: (id) =>
            ref.read(translatorStateProvider.notifier).toggleFavorite(id),
        isFavorite: (id) => state.favorites.any((r) => r.id == id),
      ),
    );
  }
}

// ─── Language Bar ─────────────────────────────────────────────────────────────

class _LanguageBar extends StatefulWidget {
  const _LanguageBar({
    required this.sourceLang,
    required this.targetLang,
    required this.langs,
    required this.isDark,
    required this.onSourceChanged,
    required this.onTargetChanged,
    required this.onSwap,
  });

  final String sourceLang;
  final String targetLang;
  final List<String> langs;
  final bool isDark;
  final ValueChanged<String> onSourceChanged;
  final ValueChanged<String> onTargetChanged;
  final VoidCallback onSwap;

  @override
  State<_LanguageBar> createState() => _LanguageBarState();
}

class _LanguageBarState extends State<_LanguageBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _swapController;
  late Animation<double> _swapRotation;

  @override
  void initState() {
    super.initState();
    _swapController = AnimationController(
      duration: const Duration(milliseconds: 350),
      vsync: this,
    );
    _swapRotation = Tween<double>(begin: 0, end: pi / 2).animate(
      CurvedAnimation(parent: _swapController, curve: Curves.easeInOut),
    );
  }

  @override
  void didUpdateWidget(_LanguageBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.sourceLang != widget.sourceLang ||
        oldWidget.targetLang != widget.targetLang) {
      _swapController.forward().then((_) {
        _swapController.reverse();
      });
    }
  }

  @override
  void dispose() {
    _swapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: widget.isDark ? AppColors.darkSurface : AppColors.surface,
        borderRadius: BorderRadius.circular(AppConstants.inputRadius),
        border: Border.all(
          color: widget.isDark
              ? AppColors.darkBorder.withValues(alpha: 0.5)
              : AppColors.border,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Expanded(child: _LanguageDropdown(value: widget.sourceLang, items: widget.langs, onChanged: widget.onSourceChanged, isDark: widget.isDark)),
          AnimatedBuilder(
            animation: _swapRotation,
            builder: (context, child) {
              return Transform.rotate(
                angle: _swapRotation.value,
                child: child,
              );
            },
            child: Pressable(
              onTap: widget.onSwap,
              child: Container(
                padding: const EdgeInsets.all(AppConstants.spacingXs),
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(AppConstants.cardRadius),
                ),
                child: const Icon(Icons.swap_horiz_rounded, color: Colors.white, size: 20),
              ),
            ),
          ),
          Expanded(child: _LanguageDropdown(value: widget.targetLang, items: widget.langs, onChanged: widget.onTargetChanged, isDark: widget.isDark)),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms);
  }
}

class _LanguageDropdown extends StatelessWidget {
  const _LanguageDropdown({
    required this.value,
    required this.items,
    required this.onChanged,
    required this.isDark,
  });

  final String value;
  final List<String> items;
  final ValueChanged<String> onChanged;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: value,
      isExpanded: true,
      underline: const SizedBox.shrink(),
      icon: Icon(
        Icons.arrow_drop_down_rounded,
        color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
        size: 20,
      ),
      style: TextStyle(
        color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
        fontWeight: FontWeight.w700,
        fontSize: 13,
      ),
      dropdownColor: isDark ? AppColors.darkSurface : AppColors.surface,
      items: items.map((lang) {
        return DropdownMenuItem<String>(
          value: lang,
          child: Text(
            lang,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        );
      }).toList(),
      onChanged: (v) {
        if (v != null) onChanged(v);
      },
    );
  }
}

// ─── Status Row ───────────────────────────────────────────────────────────────

class _StatusRow extends StatelessWidget {
  const _StatusRow({
    required this.autoTranslate,
    required this.isOnline,
    required this.detectedLang,
    required this.sourceLang,
    required this.isDark,
    required this.onToggleAuto,
  });

  final bool autoTranslate;
  final bool isOnline;
  final String? detectedLang;
  final String sourceLang;
  final bool isDark;
  final VoidCallback onToggleAuto;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.surface,
        borderRadius: BorderRadius.circular(AppConstants.inputRadius),
        border: Border.all(
          color: isDark
              ? AppColors.darkBorder.withValues(alpha: 0.5)
              : AppColors.border,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // Auto-translate toggle
          GestureDetector(
            onTap: onToggleAuto,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: autoTranslate
                    ? AppColors.primary.withValues(alpha: 0.12)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(100),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.auto_awesome_rounded,
                    size: 16,
                    color: autoTranslate ? AppColors.primary : AppColors.textTertiary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Auto',
                    style: TextStyle(
                      color: autoTranslate
                          ? AppColors.primary
                          : (isDark ? AppColors.darkTextSecondary : AppColors.textSecondary),
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const Spacer(),

          // Detected language badge
          if (sourceLang == 'Auto' && detectedLang != null && detectedLang!.isNotEmpty)
            Flexible(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.accent.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(100),
                  border: Border.all(
                    color: AppColors.accent.withValues(alpha: 0.25),
                    width: 1,
                  ),
                ),
                child: Text(
                  'Detected: ${detectedLang!.capitalize}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: AppColors.accent,
                    fontWeight: FontWeight.w700,
                    fontSize: 11,
                  ),
                ),
              ),
            ),

          const SizedBox(width: 8),

          // Connectivity dot
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isOnline ? AppColors.success : AppColors.error,
              boxShadow: [BoxShadow(
                color: (isOnline ? AppColors.success : AppColors.error).withValues(alpha: 0.5),
                blurRadius: 8,
                spreadRadius: 1,
              )],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms, delay: 100.ms);
  }
}

// ─── Source Panel ─────────────────────────────────────────────────────────────

class _SourcePanel extends StatefulWidget {
  const _SourcePanel({
    required this.text,
    required this.lang,
    required this.isListening,
    required this.isDark,
    required this.onChanged,
    required this.onMicTap,
  });

  final String text;
  final String lang;
  final bool isListening;
  final bool isDark;
  final ValueChanged<String> onChanged;
  final VoidCallback onMicTap;

  @override
  State<_SourcePanel> createState() => _SourcePanelState();
}

class _SourcePanelState extends State<_SourcePanel> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.text);
  }

  @override
  void didUpdateWidget(_SourcePanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.text != widget.text && widget.text != _controller.text) {
      _controller.value = TextEditingValue(
        text: widget.text,
        selection: TextSelection.collapsed(offset: widget.text.length),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CycloneCard(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    widget.lang == 'Auto' ? 'Source (Auto-Detect)' : 'Source (${widget.lang})',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: widget.isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ),
                const Spacer(),
                if (widget.text.trim().isNotEmpty)
                  Pressable(
                    onTap: () {
                      _controller.clear();
                      widget.onChanged('');
                    },
                    child: Icon(
                      Icons.close_rounded,
                      size: 18,
                      color: widget.isDark ? AppColors.darkTextSecondary : AppColors.textTertiary,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: AppConstants.spacingXs),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: TextField(
              controller: _controller,
              onChanged: widget.onChanged,
              maxLines: 4,
              style: TextStyle(
                color: widget.isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                fontSize: 15,
                height: 1.4,
              ),
              decoration: InputDecoration(
                hintText: 'Tap to type or use voice input...',
                hintStyle: TextStyle(
                  color: widget.isDark ? AppColors.darkTextSecondary : AppColors.textTertiary,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 8),
              ),
            ),
          ),
          const SizedBox(height: AppConstants.spacingXs),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: widget.isDark
                      ? AppColors.darkBorder.withValues(alpha: 0.4)
                      : AppColors.border.withValues(alpha: 0.6),
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                Pressable(
                  onTap: widget.onMicTap,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: widget.isListening
                          ? AppColors.success.withValues(alpha: 0.12)
                          : AppColors.primary.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          widget.isListening ? Icons.stop_rounded : Icons.mic_none_rounded,
                          size: 16,
                          color: widget.isListening ? AppColors.success : AppColors.primary,
                        ),
                        if (widget.isListening) ...[
                          const SizedBox(width: 6),
                          Text(
                            'Listening...',
                            style: TextStyle(
                              color: AppColors.success,
                              fontWeight: FontWeight.w700,
                              fontSize: 12,
                            ),
                          ).animate(onPlay: (c) => c.repeat(reverse: true)).fade(duration: 800.ms),
                        ],
                      ],
                    ),
                  ),
                ),
                const Spacer(),
                Text(
                  '${widget.text.trim().length} chars',
                  style: TextStyle(
                    color: widget.isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.textTertiary,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 350.ms, curve: Curves.easeOut);
  }
}

// ─── Translation Panel ────────────────────────────────────────────────────────

class _TranslationPanel extends StatelessWidget {
  const _TranslationPanel({
    required this.text,
    required this.isLoading,
    required this.error,
    required this.targetLang,
    required this.duration,
    required this.isSpeaking,
    required this.isDark,
    required this.isEmpty,
  });

  final String text;
  final bool isLoading;
  final String? error;
  final String targetLang;
  final Duration? duration;
  final bool isSpeaking;
  final bool isDark;
  final bool isEmpty;

  @override
  Widget build(BuildContext context) {
    return CycloneCard(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Translation ($targetLang)',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ),
                const Spacer(),
                if (duration != null)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.success.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Text(
                      '${duration!.inMilliseconds}ms',
                      style: TextStyle(
                        color: AppColors.success,
                        fontWeight: FontWeight.w700,
                        fontSize: 10,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: AppConstants.spacingXs),
          if (isLoading)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: Row(
                children: [
                  const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: AppColors.primary,
                    ),
                  ),
                   const SizedBox(width: AppConstants.spacingSm),
                  Text(
                    'Translating...',
                    style: TextStyle(
                      color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            )
          else if (error != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: AppColors.error.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(Icons.error_outline_rounded, size: 18, color: AppColors.error),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          error!,
                          style: TextStyle(
                            color: AppColors.error,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  GradientButton(
                    label: 'Retry',
                    icon: Icons.refresh_rounded,
                    height: 40,
                    onPressed: () {
                      // Triggered via parent state
                    },
                  ),
                ],
              ),
            )
          else if (!isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Text(
                text,
                style: TextStyle(
                  color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                  fontSize: 16,
                  height: 1.5,
                  fontWeight: FontWeight.w500,
                ),
              ),
            )
          else
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Text(
                'Translation will appear here...',
                style: TextStyle(
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.textTertiary,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          if (!isEmpty && !isLoading && error == null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: isDark
                        ? AppColors.darkBorder.withValues(alpha: 0.3)
                        : AppColors.border.withValues(alpha: 0.5),
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.check_circle_rounded,
                    size: 14,
                    color: AppColors.success,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Translation complete',
                    style: TextStyle(
                      color: AppColors.success,
                      fontWeight: FontWeight.w700,
                      fontSize: 11,
                    ),
                  ),
                  const Spacer(),
                  if (isSpeaking)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.accent.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Text(
                        'Playing audio...',
                        style: TextStyle(
                          color: AppColors.accent,
                          fontWeight: FontWeight.w700,
                          fontSize: 11,
                        ),
                      ),
                    ),
                ],
              ),
            )
          else if (!isEmpty)
            const SizedBox.shrink(),
        ],
      ),
    );
  }
}

// ─── Action Buttons ───────────────────────────────────────────────────────────

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.label,
    required this.isDark,
    required this.onTap,
    this.isActive = false,
  });

  final IconData icon;
  final String label;
  final bool isDark;
  final VoidCallback onTap;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    final color = isActive ? AppColors.accent : AppColors.primary;
    return Pressable(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        decoration: BoxDecoration(
          color: isActive
              ? color.withValues(alpha: 0.12)
              : AppColors.primary.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: color.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w700,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Sample Phrases ───────────────────────────────────────────────────────────

class _SamplePhrases extends StatelessWidget {
  const _SamplePhrases({required this.isDark, required this.onTap});

  final bool isDark;
  final void Function(String) onTap;

  static const _phrases = [
    'Hello, I need help at the airport.',
    'Where is my gate?',
    'Where is baggage claim?',
    'How much does this cost?',
    'Where is the restroom?',
    'Thank you very much',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick phrases',
          style: TextStyle(
            color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _phrases.map((phrase) {
            return Pressable(
              onTap: () => onTap(phrase),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.15),
                    width: 1,
                  ),
                ),
                child: Text(
                  phrase,
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ),
            );
          }).toList(),
        ).animate().fadeIn(duration: 400.ms, delay: 200.ms),
      ],
    );
  }
}

// ─── History & Favorites Bar ──────────────────────────────────────────────────

class _HistoryFavoritesBar extends StatelessWidget {
  const _HistoryFavoritesBar({
    required this.isDark,
    required this.historyCount,
    required this.favoritesCount,
    required this.onHistoryTap,
    required this.onFavoritesTap,
  });

  final bool isDark;
  final int historyCount;
  final int favoritesCount;
  final VoidCallback onHistoryTap;
  final VoidCallback onFavoritesTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Pressable(
            onTap: onHistoryTap,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurface : AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isDark
                      ? AppColors.darkBorder.withValues(alpha: 0.5)
                      : AppColors.border,
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Icon(Icons.history_rounded, size: 18, color: AppColors.primary),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      'History',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  const Spacer(),
                  if (historyCount > 0)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Text(
                        '$historyCount',
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700,
                          fontSize: 11,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Pressable(
            onTap: onFavoritesTap,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurface : AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isDark
                      ? AppColors.darkBorder.withValues(alpha: 0.5)
                      : AppColors.border,
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Icon(Icons.favorite_rounded, size: 18, color: AppColors.error),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      'Favorites',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  const Spacer(),
                  if (favoritesCount > 0)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.error.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Text(
                        '$favoritesCount',
                        style: const TextStyle(
                          color: AppColors.error,
                          fontWeight: FontWeight.w700,
                          fontSize: 11,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ],
    ).animate().fadeIn(duration: 400.ms, delay: 300.ms);
  }
}

// ─── Dialogs ──────────────────────────────────────────────────────────────────

class _HistoryDialog extends ConsumerWidget {
  const _HistoryDialog({
    required this.records,
    required this.isDark,
    required this.onClear,
  });

  final List<TranslationRecord> records;
  final bool isDark;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.read(translatorStateProvider);

    return AlertDialog(
      backgroundColor: isDark ? AppColors.darkSurface : AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.cardRadius),
        side: BorderSide(
          color: isDark ? AppColors.darkBorder.withValues(alpha: 0.5) : AppColors.border,
          width: 1,
        ),
      ),
      title: Row(
        children: [
          Expanded(
            child: Text(
              'Translation History',
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const Spacer(),
          if (records.isNotEmpty)
            Pressable(
              onTap: onClear,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: AppColors.error.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Clear',
                  style: TextStyle(color: AppColors.error, fontSize: 12, fontWeight: FontWeight.w700),
                ),
              ),
            ),
        ],
      ),
      content: records.isEmpty
          ? Text(
              'No translations yet.',
              style: TextStyle(color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary),
            )
          : SizedBox(
              width: double.maxFinite,
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: records.take(10).length,
                separatorBuilder: (_, _) => const SizedBox(height: 10),
                itemBuilder: (context, i) {
                  final r = records[i];
                  final isFav = state.favorites.any((f) => f.id == r.id);
                  return _HistoryTile(record: r, isDark: isDark, isFavorite: isFav);
                },
              ),
            ),
    );
  }
}

class _HistoryTile extends StatelessWidget {
  const _HistoryTile({required this.record, required this.isDark, required this.isFavorite});

  final TranslationRecord record;
  final bool isDark;
  final bool isFavorite;

  @override
  Widget build(BuildContext context) {
    final time = DateFormat.jm().format(record.timestamp);
    return Container(
       padding: const EdgeInsets.all(AppConstants.spacingSm),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurfaceVariant : AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark ? AppColors.darkBorder.withValues(alpha: 0.4) : AppColors.border.withValues(alpha: 0.7),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Flexible(
                child: Text(
                  '${record.sourceLang} \u2192 ${record.targetLang}',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                    fontSize: 11,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                time,
                style: TextStyle(
                  color: isDark ? AppColors.darkTextSecondary : AppColors.textTertiary,
                  fontSize: 11,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            record.sourceText,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            record.translatedText,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

class _FavoritesDialog extends ConsumerWidget {
  const _FavoritesDialog({
    required this.records,
    required this.isDark,
    required this.onClear,
    required this.onToggleFavorite,
    required this.isFavorite,
  });

  final List<TranslationRecord> records;
  final bool isDark;
  final VoidCallback onClear;
  final ValueChanged<String> onToggleFavorite;
  final bool Function(String) isFavorite;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertDialog(
      backgroundColor: isDark ? AppColors.darkSurface : AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.cardRadius),
        side: BorderSide(
          color: isDark ? AppColors.darkBorder.withValues(alpha: 0.5) : AppColors.border,
          width: 1,
        ),
      ),
      title: Row(
        children: [
          Text(
            'Favorites',
            style: TextStyle(
              color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
              fontWeight: FontWeight.w800,
            ),
          ),
          const Spacer(),
          if (records.isNotEmpty)
            Pressable(
              onTap: onClear,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: AppColors.error.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Clear',
                  style: TextStyle(color: AppColors.error, fontSize: 12, fontWeight: FontWeight.w700),
                ),
              ),
            ),
        ],
      ),
      content: records.isEmpty
          ? Text(
              'No favorites yet. Tap the heart icon after translating.',
              style: TextStyle(color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary),
            )
          : SizedBox(
              width: double.maxFinite,
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: records.take(10).length,
                separatorBuilder: (_, _) => const SizedBox(height: 10),
                itemBuilder: (context, i) {
                  final r = records[i];
                  return _FavoritesTile(
                    record: r,
                    isDark: isDark,
                    isFavorite: isFavorite(r.id),
                    onToggle: () => onToggleFavorite(r.id),
                  );
                },
              ),
            ),
    );
  }
}

class _FavoritesTile extends StatelessWidget {
  const _FavoritesTile({
    required this.record,
    required this.isDark,
    required this.isFavorite,
    required this.onToggle,
  });

  final TranslationRecord record;
  final bool isDark;
  final bool isFavorite;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return Container(
       padding: const EdgeInsets.all(AppConstants.spacingSm),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurfaceVariant : AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark ? AppColors.darkBorder.withValues(alpha: 0.4) : AppColors.border.withValues(alpha: 0.7),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${record.sourceLang} \u2192 ${record.targetLang}',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                    fontSize: 11,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  record.translatedText,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Pressable(
            onTap: onToggle,
            child: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border_rounded,
              color: AppColors.error,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }
}
