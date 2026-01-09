import 'package:flutter/material.dart';
import 'package:netearn/features/income_calculator/widgets/calculator/advanced_calculator.dart';
import 'package:netearn/features/income_calculator/widgets/calculator/calculator_tapbar.dart';
import 'package:netearn/features/income_calculator/widgets/calculator/simple_calculator.dart';
import '../../../features/income_calculator/widgets/default_appbar.dart';

class CalculatorScreen extends StatelessWidget {
  CalculatorScreen({super.key});

  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        appBar: const DefaultAppBar(
          title: 'Salary Calculator',
          icon: Icons.monetization_on,
          bottom: CalculatorTabBar(
            icons: [Icon(Icons.auto_awesome), Icon(Icons.build)],
            texts: ['Simple - Gross', 'Advanced - + Allowances'],
          ),
        ),
        body: TabBarView(
          children: [
            SimpleCalculator(
              controller: controller,
              onChanged: (value) {
                print('Salary entered: $value');
              },
            ),
            AdvancedCalculator(),
          ],
        ),
      ),
    );
  }
}
