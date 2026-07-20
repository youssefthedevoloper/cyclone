import 'package:flutter/material.dart';


import 'package:cyclone/core/theme/app_colors.dart';
import 'package:cyclone/core/constants/app_constants.dart';
import 'package:cyclone/widgets/cyclone_text_field.dart';
import 'package:cyclone/widgets/cyclone_card.dart';
import 'package:cyclone/widgets/gradient_button.dart';

class TranslatorScreen extends StatefulWidget {
  const TranslatorScreen({super.key});

  @override
  State<TranslatorScreen> createState() => _TranslatorScreenState();
}

class _TranslatorScreenState extends State<TranslatorScreen> {
  final _fromController = TextEditingController();
  final _toController = TextEditingController();

  final _languages = const [
    'English',
    'Arabic',
    'French',
    'Spanish',
    'German',
  ];

  String _fromLang = 'English';
  String _toLang = 'Arabic';

  bool _isListening = false;
  bool _isPlaying = false;

  @override
  void dispose() {
    _fromController.dispose();
    _toController.dispose();
    super.dispose();
  }

  void _mockTranslate() {
    final text = _fromController.text.trim();
    if (text.isEmpty) {
      setState(() => _toController.text = '');
      return;
    }

    // UI-first deterministic translation (no external APIs).
    // This keeps the demo stable for competitions.
    final translated = _fakeTranslation(text, _fromLang, _toLang);
    setState(() => _toController.text = translated);
  }

  String _fakeTranslation(String text, String from, String to) {
    if (from == to) return text;
    // Simple reversible-ish transformation for a "real" feel.
    final suffix = to == 'Arabic' ? ' (Arabic)' : ' ($to)';
    return '$text$suffix';
  }

  void _toggleListening() {
    setState(() => _isListening = !_isListening);

    if (!_isListening) {
      // stop
      return;
    }

    // Simulate voice input.
    Future.delayed(const Duration(milliseconds: 900), () {
      if (!mounted) return;
      setState(() {
        _fromController.text = 'Hello, I need help at the airport.';
        _isListening = false;
      });
      _mockTranslate();
    });
  }

  void _playAudio() {
    final toText = _toController.text.trim();
    if (toText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Translate something first.')),
      );
      return;
    }

    setState(() => _isPlaying = true);
    Future.delayed(const Duration(milliseconds: 700), () {
      if (!mounted) return;
      setState(() => _isPlaying = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Playing translated audio (demo).')),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: DropdownButtonFormField<String>(
                initialValue: _fromLang,
                decoration: const InputDecoration(
                  labelText: 'From',
                  border: OutlineInputBorder(),
                ),
                items: _languages
                    .map((l) => DropdownMenuItem(value: l, child: Text(l)))
                    .toList(),
                onChanged: (v) => setState(() => _fromLang = v ?? _fromLang),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: DropdownButtonFormField<String>(
                initialValue: _toLang,
                decoration: const InputDecoration(
                  labelText: 'To',
                  border: OutlineInputBorder(),
                ),
                items: _languages
                    .map((l) => DropdownMenuItem(value: l, child: Text(l)))
                    .toList(),
                onChanged: (v) => setState(() => _toLang = v ?? _toLang),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppConstants.spacingMd),

        const Text('Speak', style: TextStyle(fontWeight: FontWeight.w700)),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: CycloneCard(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Icon(
                      Icons.mic,
                      color: _isListening ? AppColors.success : AppColors.primary,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        _isListening ? 'Listening…' : 'Tap mic to speak',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                    IconButton(
                      onPressed: _toggleListening,
                      icon: Icon(_isListening ? Icons.stop : Icons.mic_none),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: AppConstants.spacingMd),

        const Text('Text Translation', style: TextStyle(fontWeight: FontWeight.w700)),
        const SizedBox(height: 8),
        Column(
          children: [
            CycloneTextField(
              controller: _fromController,
              label: 'Your message',
              hint: 'Type what you want to translate…',
            ),
            const SizedBox(height: 12),
            CycloneTextField(
              controller: _toController,
              label: 'Translation',
              hint: 'Result will appear here…',
              enabled: false,
            ),
          ],
        ),

        const SizedBox(height: AppConstants.spacingMd),
        Row(
          children: [
            Expanded(
              child: GradientButton(
                label: 'Translate',
                icon: Icons.translate,
                onPressed: _mockTranslate,
              ),
            ),
          ],
        ),

        const SizedBox(height: AppConstants.spacingMd),
        const Text('Play Audio', style: TextStyle(fontWeight: FontWeight.w700)),
        const SizedBox(height: 8),
        CycloneCard(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(Icons.volume_up, color: AppColors.primary),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  _toController.text.isEmpty ? 'No translation yet' : 'Play translated speech',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: _isPlaying ? null : _playAudio,
                icon: Icon(_isPlaying ? Icons.stop_circle_outlined : Icons.play_circle_fill),
              ),
            ],
          ),
        ),

        const SizedBox(height: AppConstants.spacingMd),
        const Text('Choose Language', style: TextStyle(fontWeight: FontWeight.w700)),
        const SizedBox(height: 6),
        Text(
          'Use the From / To selectors above. This demo keeps everything offline for reliability.',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
        ),
      ],
    );
  }
}

