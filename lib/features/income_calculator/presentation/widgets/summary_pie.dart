import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:netearn/features/income_calculator/domain/models/advanced_calculation.dart';
import 'package:netearn/features/income_calculator/domain/models/simple_calculation.dart';
import 'package:netearn/features/income_calculator/providers/calc_providers.dart';
import 'package:netearn/features/income_calculator/presentation/widgets/indicator.dart';

class AppColors {
  static const Color contentColorBlue = Color(0xFF2196F3);
  static const Color contentColorYellow = Color(0xFFFFC300);
  static const Color contentColorPurple = Color(0xFF6A0DAD);
  static const Color contentColorGreen = Color(0xFF4CAF50);
  static const Color mainTextColor1 = Colors.white;
}

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
      return _buildSimpleChart(calculation);
    } else if (calculation is AdvancedCalculation) {
      return _buildAdvancedCharts(calculation);
    }

    return const Center(
      child: Text('Unsupported calculation type for summary.'),
    );
  }

  Widget _buildSimpleChart(SimpleCalculation calculation) {
    final net = calculation.netSalary;
    final pension = calculation.pension;
    final tax = calculation.tax;
    final total = net + pension + tax;

    if (total <= 0) {
      return const Center(
        child: Text('Gross salary must be greater than zero.'),
      );
    }

    final sections = _buildNetSections(net, pension, tax, total);

    return AspectRatio(
      aspectRatio: 1.3,
      child: Row(
        children: <Widget>[
          const SizedBox(height: 18),
          Flexible(
            child: AspectRatio(
              aspectRatio: 1,
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
                        touchedIndex = pieTouchResponse
                            .touchedSection!
                            .touchedSectionIndex;
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
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const <Widget>[
              Indicator(
                color: AppColors.contentColorGreen,
                text: 'Net',
                isSquare: true,
              ),
              SizedBox(height: 4),
              Indicator(
                color: AppColors.contentColorBlue,
                text: 'Pension',
                isSquare: true,
              ),
              SizedBox(height: 4),
              Indicator(
                color: AppColors.contentColorPurple,
                text: 'Tax',
                isSquare: true,
              ),
              SizedBox(height: 18),
            ],
          ),
          const SizedBox(width: 28),
        ],
      ),
    );
  }

  Widget _buildAdvancedCharts(AdvancedCalculation calculation) {
    final basicSalary =
        calculation.grossSalary -
        calculation.transportAllowance -
        calculation.housingAllowance;

    return Column(
      children: [
        Expanded(
          child: _buildGrossChart(
            basicSalary,
            calculation.transportAllowance,
            calculation.housingAllowance,
          ),
        ),
        Expanded(
          child: _buildNetChart(
            calculation.netSalary,
            calculation.pension,
            calculation.tax,
          ),
        ),
      ],
    );
  }

  Widget _buildGrossChart(double basic, double transport, double housing) {
    final total = basic + transport + housing;
    final sections = _buildGrossSections(basic, transport, housing, total);

    return AspectRatio(
      aspectRatio: 1.3,
      child: Row(
        children: <Widget>[
          const SizedBox(height: 18),
          Expanded(
            child: AspectRatio(
              aspectRatio: 1,
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
                        grossTouchedIndex = pieTouchResponse
                            .touchedSection!
                            .touchedSectionIndex;
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
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const <Widget>[
              Indicator(
                color: AppColors.contentColorGreen,
                text: 'Basic',
                isSquare: true,
              ),
              SizedBox(height: 4),
              Indicator(
                color: AppColors.contentColorBlue,
                text: 'Transport',
                isSquare: true,
              ),
              SizedBox(height: 4),
              Indicator(
                color: AppColors.contentColorYellow,
                text: 'Housing',
                isSquare: true,
              ),
              SizedBox(height: 18),
            ],
          ),
          const SizedBox(width: 28),
        ],
      ),
    );
  }

  Widget _buildNetChart(double net, double pension, double tax) {
    final total = net + pension + tax;
    final sections = _buildNetSections(net, pension, tax, total);

    return AspectRatio(
      aspectRatio: 1.3,
      child: Row(
        children: <Widget>[
          const SizedBox(height: 18),
          Expanded(
            child: AspectRatio(
              aspectRatio: 1,
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
                        touchedIndex = pieTouchResponse
                            .touchedSection!
                            .touchedSectionIndex;
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
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const <Widget>[
              Indicator(
                color: AppColors.contentColorGreen,
                text: 'Net',
                isSquare: true,
              ),
              SizedBox(height: 4),
              Indicator(
                color: AppColors.contentColorBlue,
                text: 'Pension',
                isSquare: true,
              ),
              SizedBox(height: 4),
              Indicator(
                color: AppColors.contentColorPurple,
                text: 'Tax',
                isSquare: true,
              ),
              SizedBox(height: 18),
            ],
          ),
          const SizedBox(width: 28),
        ],
      ),
    );
  }

  List<PieChartSectionData> _buildGrossSections(
    double basic,
    double transport,
    double housing,
    double total,
  ) {
    return List.generate(3, (i) {
      final isTouched = i == grossTouchedIndex;
      final fontSize = isTouched ? 18.0 : 14.0;
      final radius = isTouched ? 65.0 : 55.0;
      const shadows = [Shadow(color: Colors.black, blurRadius: 2)];
      final textStyle = TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.bold,
        color: AppColors.mainTextColor1,
        shadows: shadows,
      );

      final basicPercent = (basic / total) * 100;
      final transportPercent = (transport / total) * 100;
      final housingPercent = (housing / total) * 100;

      switch (i) {
        case 0: // Basic
          return PieChartSectionData(
            color: AppColors.contentColorGreen,
            value: basicPercent,
            title: '${basicPercent.toStringAsFixed(0)}%',
            radius: radius,
            titleStyle: textStyle,
            badgeWidget: Text(basic.toStringAsFixed(2)),
            badgePositionPercentageOffset: 1.5,
          );
        case 1: // Transport
          return PieChartSectionData(
            color: AppColors.contentColorBlue,
            value: transportPercent,
            title: '${transportPercent.toStringAsFixed(0)}%',
            radius: radius,
            titleStyle: textStyle,
            badgeWidget: Text(transport.toStringAsFixed(2)),
            badgePositionPercentageOffset: 1.5,
          );
        case 2: // Housing
          return PieChartSectionData(
            color: AppColors.contentColorYellow,
            value: housingPercent,
            title: '${housingPercent.toStringAsFixed(0)}%',
            radius: radius,
            titleStyle: textStyle,
            badgeWidget: Text(housing.toStringAsFixed(2)),
            badgePositionPercentageOffset: 1.5,
          );
        default:
          throw Error();
      }
    });
  }

  List<PieChartSectionData> _buildNetSections(
    double net,
    double pension,
    double tax,
    double total,
  ) {
    return List.generate(3, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 18.0 : 14.0;
      final radius = isTouched ? 65.0 : 55.0;
      const shadows = [Shadow(color: Colors.black, blurRadius: 2)];
      final textStyle = TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.bold,
        color: AppColors.mainTextColor1,
        shadows: shadows,
      );

      final netPercent = (net / total) * 100;
      final pensionPercent = (pension / total) * 100;
      final taxPercent = (tax / total) * 100;

      switch (i) {
        case 0: // Net
          return PieChartSectionData(
            color: AppColors.contentColorGreen,
            value: netPercent,
            title: '${netPercent.toStringAsFixed(0)}%',
            radius: radius,
            titleStyle: textStyle,
            badgeWidget: Text(net.toStringAsFixed(2)),
            badgePositionPercentageOffset: 1.5,
          );
        case 1: // Pension
          return PieChartSectionData(
            color: AppColors.contentColorBlue,
            value: pensionPercent,
            title: '${pensionPercent.toStringAsFixed(0)}%',
            radius: radius,
            titleStyle: textStyle,
            badgeWidget: Text(pension.toStringAsFixed(2)),
            badgePositionPercentageOffset: 1.5,
          );
        case 2: // Tax
          return PieChartSectionData(
            color: AppColors.contentColorPurple,
            value: taxPercent,
            title: '${taxPercent.toStringAsFixed(0)}%',
            radius: radius,
            titleStyle: textStyle,
            badgeWidget: Text(tax.toStringAsFixed(2)),
            badgePositionPercentageOffset: 1.5,
          );
        default:
          throw Error();
      }
    });
  }
}
