import 'tax_bracket_provider.dart';

class SalaryCalculator {
  final TaxBracketProvider bracketProvider;

  static const double pensionRate = 0.07;
  static const double maxFuelExemption = 2200;

  SalaryCalculator(this.bracketProvider);

  Future<CalculationResult> calculateNet(
    double basic,
    double fuel,
    double housing,
    double mobile,
    double other,
  ) async {
    // Pension (basic only)
    final pension = basic * pensionRate;

    // Fuel exemption: 1/4 of basic, capped at 2200, and not more than fuel paid
    final fuelExempt = [
      basic / 4,
      maxFuelExemption,
      fuel,
    ].reduce((a, b) => a < b ? a : b);

    // Taxable income
    final taxable = basic + (fuel - fuelExempt) + housing + mobile + other;

    final brackets = await bracketProvider.getBrackets();
    final bracket = brackets.firstWhere(
      (b) => b.appliesTo(taxable),
      orElse: () =>
          throw Exception('No tax bracket found for income: $taxable'),
    );

    // Income tax
    final tax = (taxable * bracket.rate) - bracket.deduction;

    // Gross income (actual cash paid)
    final gross = basic + fuel + housing + mobile + other;

    // Net salary
    final net = gross - pension - tax;

    return CalculationResult(
      basic: basic,
      pension: pension,
      taxable: taxable,
      tax: tax,
      net: net,
      bracketRate: bracket.rate,
      fuelExempt: fuelExempt,
      gross: gross,
    );
  }
}

class CalculationResult {
  final double basic;
  final double pension;
  final double taxable;
  final double tax;
  final double net;
  final double bracketRate;
  final double fuelExempt;
  final double gross;

  const CalculationResult({
    required this.basic,
    required this.pension,
    required this.taxable,
    required this.tax,
    required this.net,
    required this.bracketRate,
    required this.fuelExempt,
    required this.gross,
  });

  double get totalDeductions => pension + tax;
  double get takeHomePercentage => (net / gross) * 100;
}
