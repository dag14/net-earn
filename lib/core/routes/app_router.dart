import 'package:go_router/go_router.dart';
import 'package:netearn/core/presentation/screens/tabs_screen.dart';
import '../presentation/screens/calculator_screen.dart';
import '../presentation/screens/history_screen.dart';
import '../presentation/screens/insights_screen.dart';
import '../presentation/screens/settings_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/calculator',
  routes: [
    ShellRoute(
      builder: (context, state, child) => TabsScreen(child: child),
      routes: [
        GoRoute(path: '/calculator', builder: (_, __) => CalculatorScreen()),
        GoRoute(path: '/history', builder: (_, __) => const HistoryScreen()),
        GoRoute(
          path: '/insights',
          builder: (_, __) => const InsightsScreen(), // Coming Soon
        ),
        GoRoute(path: '/settings', builder: (_, __) => const SettingsScreen()),
      ],
    ),
  ],
);
