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

class SalaryCalculatorNotifier extends StateNotifier<List<Calculation>> {
  final BasicSalaryCalculator _calculator;

  SalaryCalculatorNotifier(this._calculator) : super([]);

  Future<void> calculate(double grossSalary) async {
    final result = await _calculator.calculateNet(grossSalary);
    final calculation = SimpleCalculation(
      grossSalary: grossSalary,
      netSalary: result.net,
      pension: result.pension,
      tax: result.tax,
    );
    state = [...state, calculation];
  }

  void clear() {
    state = [];
  }
}

final salaryCalculatorProvider =
    StateNotifierProvider<SalaryCalculatorNotifier, List<Calculation>>((ref) {
      final calculator = ref.watch(basicSalaryCalculatorProvider);
      return SalaryCalculatorNotifier(calculator);
    });

final calculationHistoryProvider = Provider<List<Calculation>>((ref) {
  return ref.watch(salaryCalculatorProvider);
});

final lastCalculationProvider = Provider<Calculation?>((ref) {
  final history = ref.watch(salaryCalculatorProvider);
  if (history.isEmpty) {
    return null;
  }
  return history.last;
});
