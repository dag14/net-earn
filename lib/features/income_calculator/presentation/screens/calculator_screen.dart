import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:netearn/features/income_calculator/data/local_tax_bracket_provider.dart';
import 'package:netearn/features/income_calculator/domain/salary_calculator.dart'
    as domain;
import 'package:netearn/features/income_calculator/presentation/widgets/calculator_tapbar.dart';
import 'package:netearn/features/income_calculator/presentation/widgets/salary_calculator.dart'
    as presentation;
import 'package:netearn/features/income_calculator/presentation/widgets/salary_summary.dart';
import 'package:netearn/features/income_calculator/providers/calc_providers.dart';
import 'package:intl/intl.dart';
import 'package:netearn/core/theme/app_theme.dart';
import 'package:netearn/features/income_calculator/domain/models/calculation.dart';
import 'package:netearn/features/income_calculator/domain/models/salary_calculation.dart';
import 'package:netearn/features/income_calculator/domain/models/advanced_calculation.dart';
import '../../../../core/presentation/widgets/default_appbar.dart';

class CalculatorScreen extends ConsumerStatefulWidget {
  const CalculatorScreen({super.key});

  @override
  ConsumerState<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends ConsumerState<CalculatorScreen> {
  late final TextEditingController controller;
  late final domain.SalaryCalculator calculator;
  Object? _lastShownCalculation;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
    calculator = domain.SalaryCalculator(LocalTaxBracketProvider());
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _showCalculationModal(BuildContext context, Calculation calc) {
    final NumberFormat formatter = NumberFormat('#,##0.##');
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).dialogBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      builder: (ctx) {
        return FractionallySizedBox(
          heightFactor: 0.85,
          child: Padding(
            padding: MediaQuery.of(ctx).viewInsets,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 12),
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Theme.of(ctx).dividerColor,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Calculation Results (text rows)
                  if (calc is SalaryCalculation) ...[
                    _resultsBlock(
                      ctx,
                      formatter,
                      calc.netSalary,
                      calc.tax,
                      calc.pension,
                    ),
                  ] else if (calc is AdvancedCalculation) ...[
                    _resultsBlock(
                      ctx,
                      formatter,
                      calc.netSalary,
                      calc.tax,
                      calc.pension,
                    ),
                  ],

                  const SizedBox(height: 12),

                  // SalarySummary should appear second
                  SizedBox(height: 250, child: SalarySummary()),

                  const SizedBox(height: 12),

                  // Details after SalarySummary
                  if (calc is SalaryCalculation) ...[
                    _salaryDetailsBlock(ctx, formatter, salary: calc),
                  ] else if (calc is AdvancedCalculation) ...[
                    _advancedDetailsBlock(ctx, formatter, advanced: calc),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _resultsBlock(
    BuildContext ctx,
    NumberFormat formatter,
    double net,
    double tax,
    double pension,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(ctx).colorScheme.surfaceVariant.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            'Calculation Results',
            style: Theme.of(
              ctx,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
          ),
          const Divider(height: 24),
          _buildResultRow(
            ctx,
            'Net Salary',
            formatter.format(net),
            AppTheme.success,
            isBold: true,
          ),
          const SizedBox(height: 12),
          _buildResultRow(
            ctx,
            'Income Tax',
            formatter.format(tax),
            AppTheme.red,
            isBold: true,
          ),
          const SizedBox(height: 12),
          _buildResultRow(
            ctx,
            'Pension',
            formatter.format(pension),
            AppTheme.blue,
            isBold: true,
          ),
        ],
      ),
    );
  }

  Widget _salaryDetailsBlock(
    BuildContext ctx,
    NumberFormat formatter, {
    required SalaryCalculation salary,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(ctx).colorScheme.surfaceVariant.withOpacity(0.18),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Details',
            style: Theme.of(
              ctx,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          _buildResultRow(
            ctx,
            'Gross Salary',
            formatter.format(salary.gross),
            Theme.of(ctx).colorScheme.onSurface,
          ),
          const SizedBox(height: 8),
          _buildResultRow(
            ctx,
            'Fuel Exempt',
            formatter.format(salary.fuelExempt),
            Theme.of(ctx).colorScheme.onSurface,
          ),
          const SizedBox(height: 8),
          _buildResultRow(
            ctx,
            'Taxable Income',
            formatter.format(salary.taxable),
            Theme.of(ctx).colorScheme.onSurface,
          ),
          const SizedBox(height: 8),
          _buildResultRow(
            ctx,
            'Basic Salary',
            formatter.format(salary.basicSalary),
            Theme.of(ctx).colorScheme.onSurface,
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Bracket Rate',
                style: Theme.of(ctx).textTheme.bodyLarge?.copyWith(),
              ),
              Text(
                '${(salary.bracketRate * 100).toStringAsFixed(2)}%',
                style: Theme.of(
                  ctx,
                ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _advancedDetailsBlock(
    BuildContext ctx,
    NumberFormat formatter, {
    required AdvancedCalculation advanced,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(ctx).colorScheme.surfaceVariant.withOpacity(0.18),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Details',
            style: Theme.of(
              ctx,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          _buildResultRow(
            ctx,
            'Gross Salary',
            formatter.format(advanced.grossSalary),
            Theme.of(ctx).colorScheme.onSurface,
          ),
          const SizedBox(height: 8),
          _buildResultRow(
            ctx,
            'Transport',
            formatter.format(advanced.transportAllowance),
            Theme.of(ctx).colorScheme.onSurface,
          ),
          const SizedBox(height: 8),
          _buildResultRow(
            ctx,
            'Housing',
            formatter.format(advanced.housingAllowance),
            Theme.of(ctx).colorScheme.onSurface,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // listen for calculation changes inside build (ConsumerState requirement)
    ref.listen<Calculation?>(lastCalculationProvider, (previous, next) {
      if (next != null && next != _lastShownCalculation) {
        _lastShownCalculation = next;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          _showCalculationModal(context, next);
        });
      }
    });

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: const DefaultAppBar(
          title: 'Salary Calculator',
          icon: Icons.monetization_on,
          bottom: CalculatorTabBar(
            icons: [Icon(Icons.money), Icon(Icons.undo_rounded)],
            texts: ['Gross - Net', 'Net - Gross'],
          ),
        ),
        body: Column(
          children: [
            SizedBox(
              height: 550,
              child: TabBarView(
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  presentation.SalaryCalculator(controller: controller),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultRow(
    BuildContext context,
    String label,
    String value,
    Color color, {
    bool isBold = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: color.withOpacity(isBold ? 1.0 : 0.85),
            fontWeight: isBold ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
        Text(
          '$value ETB',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: color,
            fontWeight: isBold ? FontWeight.w700 : FontWeight.w600,
            fontSize: isBold ? 18 : 16,
          ),
        ),
      ],
    );
  }
}
