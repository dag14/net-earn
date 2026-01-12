import 'package:netearn/features/income_calculator/domain/models/calculation.dart';

class AdvancedCalculation extends Calculation {
  final double grossSalary;
  final double transportAllowance;
  final double housingAllowance;
  @override
  final double netSalary;
  @override
  final double pension;
  @override
  final double tax;

  AdvancedCalculation({
    required this.grossSalary,
    required this.transportAllowance,
    required this.housingAllowance,
    required this.netSalary,
    required this.pension,
    required this.tax,
  });
}
