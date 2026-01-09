import 'package:flutter/material.dart';
import 'package:netearn/core/widgets/default_appbar.dart';

class InsightsScreen extends StatelessWidget {
  const InsightsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const DefaultAppBar(),
      body: const Center(child: Text('Insights Screen Content')),
    );
  }
}
