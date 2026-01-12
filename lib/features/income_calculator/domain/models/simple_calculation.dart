import 'package:netearn/features/income_calculator/domain/models/calculation.dart';

class SimpleCalculation extends Calculation {
  final double grossSalary;
  @override
  final double netSalary;
  @override
  final double pension;
  @override
  final double tax;

  SimpleCalculation({
    required this.grossSalary,
    required this.netSalary,
    required this.pension,
    required this.tax,
  });
}
