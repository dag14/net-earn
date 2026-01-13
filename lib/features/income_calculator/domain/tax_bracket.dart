class TaxBracket {
  final double min;
  final double? max;
  final double rate;
  final double deduction;

  const TaxBracket({
    required this.min,
    this.max,
    required this.rate,
    required this.deduction,
  });

  bool appliesTo(double income) {
    if (max == null) return income >= min;
    return income >= min && income <= max!;
  }
}
