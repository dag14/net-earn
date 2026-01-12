import '../domain/tax_bracket.dart';
import '../domain/tax_bracket_provider.dart';

class LocalTaxBracketProvider implements TaxBracketProvider {
  @override
  Future<List<TaxBracket>> getBrackets() async {
    return const [
      TaxBracket(min: 0, max: 2000, rate: 0.0, deduction: 0),
      TaxBracket(min: 2000, max: 4000, rate: 0.15, deduction: 300),
      TaxBracket(min: 4000, max: 7000, rate: 0.20, deduction: 500),
      TaxBracket(min: 7000, max: 10000, rate: 0.25, deduction: 850),
      TaxBracket(min: 10000, max: 14000, rate: 0.30, deduction: 1350),
      TaxBracket(min: 14000, max: null, rate: 0.35, deduction: 2050),
    ];
  }
}
