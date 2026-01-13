import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:netearn/core/theme/app_theme.dart'; // Added import
import 'package:netearn/features/income_calculator/domain/models/advanced_calculation.dart';
import 'package:netearn/features/income_calculator/domain/models/simple_calculation.dart';
import 'package:netearn/features/income_calculator/providers/calc_providers.dart';
import 'package:netearn/features/income_calculator/presentation/widgets/indicator.dart';

// Removed AppColors class

class SalarySummary extends ConsumerStatefulWidget {
  const SalarySummary({super.key});

  @override
  ConsumerState<SalarySummary> createState() => _SalarySummaryState();
}

class _SalarySummaryState extends ConsumerState<SalarySummary> {
  int touchedIndex = -1;
  int grossTouchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    final calculation = ref.watch(lastCalculationProvider);

    if (calculation == null) {
      return const Center(child: Text('Perform a calculation to see summary'));
    }

    if (calculation is SimpleCalculation) {
      return _buildSimpleChart(context, calculation); // Added context
    } else if (calculation is AdvancedCalculation) {
      return _buildAdvancedCharts(context, calculation); // Added context
    }

    return const Center(
      child: Text('Unsupported calculation type for summary.'),
    );
  }

  Widget _buildSimpleChart(
    BuildContext context,
    SimpleCalculation calculation,
  ) {
    // Added context
    final net = calculation.netSalary;
    final pension = calculation.pension;
    final tax = calculation.tax;
    final total = net + pension + tax;

    if (total <= 0) {
      return const Center(
        child: Text('Gross salary must be greater than zero.'),
      );
    }

    final sections = _buildNetSections(
      context,
      net,
      pension,
      tax,
      total,
    ); // Added context

    return Row(
      children: <Widget>[
        Expanded(
          child: PieChart(
            PieChartData(
              pieTouchData: PieTouchData(
                touchCallback: (FlTouchEvent event, pieTouchResponse) {
                  setState(() {
                    if (!event.isInterestedForInteractions ||
                        pieTouchResponse == null ||
                        pieTouchResponse.touchedSection == null) {
                      touchedIndex = -1;
                      return;
                    }
                    touchedIndex =
                        pieTouchResponse.touchedSection!.touchedSectionIndex;
                  });
                },
              ),
              borderData: FlBorderData(show: false),
              sectionsSpace: 0,
              centerSpaceRadius: 40,
              sections: sections,
            ),
          ),
        ),
        // Column(
        //   mainAxisAlignment: MainAxisAlignment.end,
        //   crossAxisAlignment: CrossAxisAlignment.start,
        //   children: const <Widget>[
        //     Indicator(
        //       color: AppTheme.success,
        //       text: 'Net',
        //       isSquare: true,
        //     ),
        //     SizedBox(height: 4),
        //     Indicator(
        //       color: AppTheme.blue,
        //       text: 'Pension',
        //       isSquare: true,
        //     ),
        //     SizedBox(height: 4),
        //     Indicator(
        //       color: AppTheme.purple,
        //       text: 'Tax',
        //       isSquare: true,
        //     ),
        //     SizedBox(height: 18),
        //   ],
        // ),
        // const SizedBox(width: 28),
      ],
    );
  }

  Widget _buildAdvancedCharts(
    BuildContext context,
    AdvancedCalculation calculation,
  ) {
    // Added context
    final basicSalary =
        calculation.grossSalary -
        calculation.transportAllowance -
        calculation.housingAllowance;

    return Column(
      children: [
        Expanded(
          child: _buildGrossChart(
            context, // Added context
            basicSalary,
            calculation.transportAllowance,
            calculation.housingAllowance,
          ),
        ),
        Expanded(
          child: _buildNetChart(
            context, // Added context
            calculation.netSalary,
            calculation.pension,
            calculation.tax,
          ),
        ),
      ],
    );
  }

  Widget _buildGrossChart(
    BuildContext context,
    double basic,
    double transport,
    double housing,
  ) {
    // Added context
    final total = basic + transport + housing;
    final sections = _buildGrossSections(
      context,
      basic,
      transport,
      housing,
      total,
    ); // Added context

    return Row(
      children: <Widget>[
        Expanded(
          child: PieChart(
            PieChartData(
              pieTouchData: PieTouchData(
                touchCallback: (FlTouchEvent event, pieTouchResponse) {
                  setState(() {
                    if (!event.isInterestedForInteractions ||
                        pieTouchResponse == null ||
                        pieTouchResponse.touchedSection == null) {
                      grossTouchedIndex = -1;
                      return;
                    }
                    grossTouchedIndex =
                        pieTouchResponse.touchedSection!.touchedSectionIndex;
                  });
                },
              ),
              borderData: FlBorderData(show: false),
              sectionsSpace: 0,
              // centerSpaceRadius: 40,
              sections: sections,
            ),
          ),
        ),
        // Column(
        //   mainAxisAlignment: MainAxisAlignment.end,
        //   crossAxisAlignment: CrossAxisAlignment.start,
        //   children: const <Widget>[
        //     Indicator(
        //       color: AppTheme.success,
        //       text: 'Basic',
        //       isSquare: true,
        //     ),
        //     SizedBox(height: 4),
        //     Indicator(
        //       color: AppTheme.blue,
        //       text: 'Transport',
        //       isSquare: true,
        //     ),
        //     SizedBox(height: 4),
        //     Indicator(
        //       color: AppTheme.amber,
        //       text: 'Housing',
        //       isSquare: true,
        //     ),
        //     SizedBox(height: 18),
        //   ],
        // ),
        // const SizedBox(width: 28),
      ],
    );
  }

  Widget _buildNetChart(
    BuildContext context,
    double net,
    double pension,
    double tax,
  ) {
    // Added context
    final total = net + pension + tax;
    final sections = _buildNetSections(
      context,
      net,
      pension,
      tax,
      total,
    ); // Added context

    return PieChart(
      PieChartData(
        pieTouchData: PieTouchData(
          touchCallback: (FlTouchEvent event, pieTouchResponse) {
            setState(() {
              if (!event.isInterestedForInteractions ||
                  pieTouchResponse == null ||
                  pieTouchResponse.touchedSection == null) {
                touchedIndex = -1;
                return;
              }
              touchedIndex =
                  pieTouchResponse.touchedSection!.touchedSectionIndex;
            });
          },
        ),
        borderData: FlBorderData(show: false),
        sectionsSpace: 0,
        // centerSpaceRadius: 40,
        sections: sections,
      ),
    );
  }

  List<PieChartSectionData> _buildGrossSections(
    BuildContext context, // Added context
    double basic,
    double transport,
    double housing,
    double total,
  ) {
    return List.generate(3, (i) {
      final isTouched = i == grossTouchedIndex;
      final fontSize = isTouched ? 18.0 : 14.0;
      final radius = isTouched ? 65.0 : 55.0;
      final shadows = [
        Shadow(color: Theme.of(context).shadowColor, blurRadius: 2),
      ];
      final textStyle = Theme.of(context).textTheme.bodyMedium?.copyWith(
        fontSize: fontSize,
        fontWeight: FontWeight.bold,
        color: Theme.of(context).colorScheme.onSurface,
        shadows: shadows,
      );

      final basicPercent = (basic / total) * 100;
      final transportPercent = (transport / total) * 100;
      final housingPercent = (housing / total) * 100;

      switch (i) {
        case 0: // Basic
          return PieChartSectionData(
            color: AppTheme.success,
            value: basicPercent,
            title: '${basicPercent.toStringAsFixed(0)}%',
            radius: radius,
            titleStyle: textStyle,
          );
        case 1:
          return PieChartSectionData(
            color: AppTheme.blue,
            value: transportPercent,
            title: '${transportPercent.toStringAsFixed(0)}%',
            radius: radius,
            titleStyle: textStyle,
          );
        case 2:
          return PieChartSectionData(
            color: AppTheme.amber,
            value: housingPercent,
            title: '${housingPercent.toStringAsFixed(0)}%',
            radius: radius,
            titleStyle: textStyle,
          );
        default:
          throw Error();
      }
    });
  }

  List<PieChartSectionData> _buildNetSections(
    BuildContext context, // Added context
    double net,
    double pension,
    double tax,
    double total,
  ) {
    return List.generate(3, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 18.0 : 14.0;
      final radius = isTouched ? 65.0 : 55.0;
      final shadows = [
        Shadow(color: Theme.of(context).shadowColor, blurRadius: 2),
      ];
      final textStyle = Theme.of(context).textTheme.bodyMedium?.copyWith(
        fontSize: fontSize,
        fontWeight: FontWeight.bold,
        color: Theme.of(context).colorScheme.onSurface,
        shadows: shadows,
      );

      final netPercent = (net / total) * 100;
      final pensionPercent = (pension / total) * 100;
      final taxPercent = (tax / total) * 100;

      switch (i) {
        case 0: // Net
          return PieChartSectionData(
            color: AppTheme.success,
            value: netPercent,
            title: '${netPercent.toStringAsFixed(0)}%',
            radius: radius,
            titleStyle: textStyle,
          );
        case 1: // Pension
          return PieChartSectionData(
            color: AppTheme.blue,
            value: pensionPercent,
            title: '${pensionPercent.toStringAsFixed(0)}%',
            radius: radius,
            titleStyle: textStyle,
          );
        case 2: // Tax
          return PieChartSectionData(
            color: AppTheme.red,
            value: taxPercent,
            title: '${taxPercent.toStringAsFixed(0)}%',
            radius: radius,
            titleStyle: textStyle,
          );
        default:
          throw Error();
      }
    });
  }
}
