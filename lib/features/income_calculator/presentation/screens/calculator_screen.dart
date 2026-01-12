import 'package:flutter/material.dart';
import 'package:netearn/features/income_calculator/data/local_tax_bracket_provider.dart';
import 'package:netearn/features/income_calculator/domain/basic_salary_calculator.dart';
import 'package:netearn/features/income_calculator/presentation/widgets/advanced_calculator.dart';
import 'package:netearn/features/income_calculator/presentation/widgets/calculator_tapbar.dart';
import 'package:netearn/features/income_calculator/presentation/widgets/simple_calculator.dart';
import 'package:netearn/features/income_calculator/presentation/widgets/summary_pie.dart';
import '../../../../core/presentation/widgets/default_appbar.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  late final TextEditingController controller;
  late final BasicSalaryCalculator calculator;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
    calculator = BasicSalaryCalculator(LocalTaxBracketProvider());
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

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
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [],
          body: Column(
            children: [
              SizedBox(
                height: 260,
                child: TabBarView(
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    SimpleCalculator(controller: controller),
                    AdvancedCalculator(),
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: SalarySummary(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
