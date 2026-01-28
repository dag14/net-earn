import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:netearn/features/income_calculator/data/local_tax_bracket_provider.dart';
import 'package:netearn/features/income_calculator/domain/salary_calculator.dart';
import 'package:netearn/features/income_calculator/domain/models/calculation.dart';
import 'package:netearn/features/income_calculator/domain/models/salary_calculation.dart';
import 'package:netearn/features/income_calculator/domain/tax_bracket_provider.dart';

final taxBracketProvider = Provider<TaxBracketProvider>((ref) {
  return LocalTaxBracketProvider();
});

final salaryCalculatorProvider = Provider<SalaryCalculator>((ref) {
  final taxBracketProviderInstance = ref.watch(taxBracketProvider);
  return SalaryCalculator(taxBracketProviderInstance);
});

class SalaryCalculatorNotifier extends StateNotifier<List<Calculation>> {
  final SalaryCalculator _calculator;

  SalaryCalculatorNotifier(this._calculator) : super([]);

  Future<void> calculate(
    double basicSalary,
    double fuelAllowance,
    double housingAllowance,
    double mobileAllowance,
    double otherAllowances,
  ) async {
    final result = await _calculator.calculateNet(
      basicSalary,
      fuelAllowance,
      housingAllowance,
      mobileAllowance,
      otherAllowances,
    );
    final calculation = SalaryCalculation(
      basicSalary: basicSalary,
      netSalary: result.net,
      pension: result.pension,
      tax: result.tax,
      gross: result.gross,
      fuelExempt: result.fuelExempt,
      taxable: result.taxable,
      bracketRate: result.bracketRate,
    );
    state = [...state, calculation];
  }

  void clear() {
    state = [];
  }
}

final salaryCalculatorHistoryProvider =
    StateNotifierProvider<SalaryCalculatorNotifier, List<Calculation>>((ref) {
      final calculator = ref.read(salaryCalculatorProvider);
      return SalaryCalculatorNotifier(calculator);
    });

final calculationHistoryProvider = Provider<List<Calculation>>((ref) {
  return ref.watch(salaryCalculatorHistoryProvider);
});

final lastCalculationProvider = Provider<Calculation?>((ref) {
  final history = ref.watch(salaryCalculatorHistoryProvider);
  if (history.isEmpty) {
    return null;
  }
  return history.last;
});
