import 'package:flutter/material.dart';
import 'package:netearn/core/widgets/default_appbar.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const DefaultAppBar(title: 'History', icon: Icons.history),
      body: const Center(child: Text('History Screen Content')),
    );
  }
}
