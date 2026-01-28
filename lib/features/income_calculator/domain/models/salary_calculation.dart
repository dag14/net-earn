import 'package:netearn/features/income_calculator/domain/models/calculation.dart';

class SalaryCalculation extends Calculation {
  final double basicSalary;
  @override
  final double netSalary;
  @override
  final double pension;
  @override
  final double tax;

  // Additional fields carried from CalculationResult
  final double gross;
  final double fuelExempt;
  final double taxable;
  final double bracketRate;

  SalaryCalculation({
    required this.basicSalary,
    required this.netSalary,
    required this.pension,
    required this.tax,
    required this.gross,
    required this.fuelExempt,
    required this.taxable,
    required this.bracketRate,
  });
}
