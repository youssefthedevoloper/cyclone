import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/config/router/app_router.dart';
import 'core/config/settings_provider.dart';
import 'core/constants/app_constants.dart';
import 'core/services/storage_service.dart';
import 'core/theme/app_theme.dart';
import 'features/authentication/presentation/providers/auth_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final storageService = await StorageService.init();

  runApp(
    ProviderScope(
      overrides: [
        storageServiceProvider.overrideWithValue(storageService),
      ],
      child: const CycloneApp(),
    ),
  );
}

class CycloneApp extends ConsumerWidget {
  const CycloneApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final settings = ref.watch(settingsProvider);

    return MaterialApp.router(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(textScale: settings.textScale),
      darkTheme: AppTheme.dark(textScale: settings.textScale),
      themeMode: settings.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      routerConfig: router,
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: TextScaler.linear(settings.textScale),
          ),
          child: child!,
        );
      },
    );
  }
}
