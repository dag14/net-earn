import 'package:netearn/features/income_calculator/domain/models/calculation.dart';

class SimpleCalculation extends Calculation {
  final double grossSalary;
  @override
  final double netSalary;

  SimpleCalculation({required this.grossSalary, required this.netSalary});
}
