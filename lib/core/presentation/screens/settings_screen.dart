import 'package:flutter/material.dart';
import 'package:netearn/core/presentation/widgets/default_appbar.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const DefaultAppBar(title: 'Settings', icon: Icons.settings),
      body: const Center(child: Text('Settings Screen Content')),
    );
  }
}
