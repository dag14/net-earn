import 'package:netearn/features/income_calculator/domain/models/calculation.dart';

class AdvancedCalculation extends Calculation {
  final double grossSalary;
  final double transportAllowance;
  final double housingAllowance;
  @override
  final double netSalary;

  AdvancedCalculation({
    required this.grossSalary,
    required this.transportAllowance,
    required this.housingAllowance,
    required this.netSalary,
  });
}
