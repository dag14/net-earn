import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'calculator_screen.dart';
import 'history_screen.dart';
import 'insights_screen.dart';
import 'settings_screen.dart';

class TabsScreen extends ConsumerWidget {
  const TabsScreen({super.key});

  static const tabs = ['/calculator', '/history', '/insights', '/settings'];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final location = GoRouterState.of(context).uri.toString();
    final currentIndex = tabs.indexWhere((path) => location.startsWith(path));

    return Scaffold(
      body: _buildCurrentScreen(location),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex < 0 ? 0 : currentIndex,
        onTap: (index) => context.go(tabs[index]),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.calculate),
            label: "Calculator",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: "History"),
          BottomNavigationBarItem(
            icon: Icon(Icons.insights),
            label: "Insights",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: "Settings",
          ),
        ],
      ),
    );
  }
}

Widget _buildCurrentScreen(String location) {
  if (location.startsWith('/calculator')) return const CalculatorScreen();
  if (location.startsWith('/history')) return const HistoryScreen();
  if (location.startsWith('/insights')) return const InsightsScreen();
  if (location.startsWith('/settings')) return const SettingsScreen();
  return const Center(child: Text('Page not found'));
}
