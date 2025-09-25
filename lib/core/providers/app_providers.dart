import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import '../services/theme_service.dart';

/// Controls theme mode (light/dark/system)

final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeMode>((ref) {
  return ThemeNotifier();
});

// App Update Status Provider

// final appUpdateProvider = FutureProvider<bool>((ref) async {
//   final service = AppUpdateService();
//   return await service.checkForUpdate();
// });
