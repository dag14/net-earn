import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'core/providers/app_providers.dart';

void main() {
  runApp(const ProviderScope(child: NetEarnApp()));
}

class NetEarnApp extends ConsumerWidget {
  const NetEarnApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);

    return MaterialApp(
      title: 'NetEarn',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode, // dynamic toggle
      home: const Placeholder(), // will replace with GoRouter soon
    );
  }
}
