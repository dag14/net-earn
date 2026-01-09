import 'package:flutter/material.dart';
import 'package:netearn/core/widgets/calculator_tapbar.dart';
import '../../widgets/default_appbar.dart';

class CalculatorScreen extends StatelessWidget {
  const CalculatorScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 1,
      length: 2,
      child: Scaffold(
        appBar: const DefaultAppBar(
          title: 'Salary Calculator',
          icon: Icons.calculate,
          bottom: CalculatorTabBar(
            icons: [Icon(Icons.auto_awesome), Icon(Icons.build)],
            texts: ['Simple - Gross', 'Advanced - + Allowances'],
          ),
        ),
        body: const Center(child: Text('Calculator Screen Content')),
      ),
    );
  }
}
