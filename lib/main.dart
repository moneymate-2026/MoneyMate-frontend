import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/splash/presentation/pages/splashscreen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_controller.dart';
// ... your other imports

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MoneyMate',
      theme: AppTheme.lightTheme,   // we'll create this next
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,          // now controlled by the provider
      home: const SplashScreen(),
    );
  }
}