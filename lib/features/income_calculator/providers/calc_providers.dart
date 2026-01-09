import 'package:flutter_riverpod/flutter_riverpod.dart';

// Placeholder StateNotifier
class CalculatorNotifier extends StateNotifier<dynamic> {
  CalculatorNotifier() : super(null);

  void calculate(dynamic input) {
    // TODO: implement when use cases are ready
    throw UnimplementedError();
  }

  void clear() {
    state = null;
  }
}

// Placeholder Provider
final calculatorProvider = StateNotifierProvider<CalculatorNotifier, dynamic>((
  ref,
) {
  return CalculatorNotifier();
});
