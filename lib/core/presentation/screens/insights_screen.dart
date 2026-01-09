import 'package:flutter/material.dart';
import 'package:netearn/features/income_calculator/widgets/default_appbar.dart';

class InsightsScreen extends StatelessWidget {
  const InsightsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const DefaultAppBar(title: 'Insights', icon: Icons.insights),
      body: const Center(child: Text('Insights Screen Content')),
    );
  }
}
