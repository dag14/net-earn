import 'package:netearn/features/income_calculator/domain/tax_bracket.dart';

abstract class TaxBracketProvider {
  Future<List<TaxBracket>> getBrackets();
}
