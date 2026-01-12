import 'tax_bracket_provider.dart';

class BasicSalaryCalculator {
  final TaxBracketProvider bracketProvider;
  static const double pensionRate = 0.07;

  BasicSalaryCalculator(this.bracketProvider);

  Future<double> calculateNet(double gross) async {
    final pension = gross * pensionRate;
    final taxable = gross;

    final brackets = await bracketProvider.getBrackets();
    final bracket = brackets.firstWhere(
      (b) => b.appliesTo(taxable),
      orElse: () =>
          throw Exception('No tax bracket found for income: $taxable'),
    );

    final tax = (taxable * bracket.rate) - bracket.deduction;

    return gross - pension - tax;
  }
}

class CalculationResult {
  final double gross;
  final double pension;
  final double taxable;
  final double tax;
  final double net;
  final double bracketRate;

  const CalculationResult({
    required this.gross,
    required this.pension,
    required this.taxable,
    required this.tax,
    required this.net,
    required this.bracketRate,
  });

  double get totalDeductions => pension + tax;
  double get takeHomePercentage => (net / gross) * 100;
}
