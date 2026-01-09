import 'package:flutter/material.dart';
import '../../widgets/default_appbar.dart';

class CalculatorScreen extends StatelessWidget {
  const CalculatorScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const DefaultAppBar(),
      body: const Center(child: Text('Calculator Screen Content')),
    );
  }
}
