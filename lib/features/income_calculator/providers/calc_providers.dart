import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:netearn/features/income_calculator/data/local_tax_bracket_provider.dart';
import 'package:netearn/features/income_calculator/domain/basic_salary_calculator.dart';
import 'package:netearn/features/income_calculator/domain/models/calculation.dart';
import 'package:netearn/features/income_calculator/domain/models/simple_calculation.dart';
import 'package:netearn/features/income_calculator/domain/tax_bracket_provider.dart';

final taxBracketProvider = Provider<TaxBracketProvider>((ref) {
  return LocalTaxBracketProvider();
});

final basicSalaryCalculatorProvider = Provider<BasicSalaryCalculator>((ref) {
  final taxBracketProviderInstance = ref.watch(taxBracketProvider);
  return BasicSalaryCalculator(taxBracketProviderInstance);
});

class SimpleCalculatorNotifier extends StateNotifier<List<Calculation>> {
  final BasicSalaryCalculator _calculator;

  SimpleCalculatorNotifier(this._calculator) : super([]);

  Future<void> calculate(double grossSalary) async {
    final netSalary = await _calculator.calculateNet(grossSalary);
    final calculation = SimpleCalculation(grossSalary: grossSalary, netSalary: netSalary);
    state = [...state, calculation];
  }

  void clear() {
    state = [];
  }
}

final simpleCalculatorProvider =
    StateNotifierProvider<SimpleCalculatorNotifier, List<Calculation>>((ref) {
      final calculator = ref.watch(basicSalaryCalculatorProvider);
      return SimpleCalculatorNotifier(calculator);
    });

final calculationHistoryProvider = Provider<List<Calculation>>((ref) {
  return ref.watch(simpleCalculatorProvider);
});

final lastCalculationProvider = Provider<Calculation?>((ref) {
  final history = ref.watch(simpleCalculatorProvider);
  if (history.isEmpty) {
    return null;
  }
  return history.last;
});
