import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:netearn/features/income_calculator/providers/calc_providers.dart';

class SimpleCalculator extends ConsumerWidget {
  final TextEditingController controller;

  const SimpleCalculator({super.key, required this.controller});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final NumberFormat formatter = NumberFormat('#,##0.##');
    final calculation = ref.watch(lastCalculationProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.payment, size: 24),
              const SizedBox(width: 8),
              Text(
                'Gross to Net',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextField(
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontSize: 24),
            controller: controller,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[\d.,]')),
              InputFormatter(),
            ],
            decoration: const InputDecoration(
              labelText: 'Enter Gross Salary (ETB)',
            ),
            onEditingComplete: () async {
              final rawText = controller.text.replaceAll(',', '');
              final gross = double.tryParse(rawText) ?? 0;

              await ref
                  .read(simpleCalculatorProvider.notifier)
                  .calculate(gross);

              // Dismiss keyboard
              FocusScope.of(context).unfocus();
            },
          ),
          const SizedBox(height: 24),
          if (calculation != null) ...[
            Text(
              'Net Salary: ${formatter.format(calculation.netSalary)} ETB',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontSize: 18,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            Text(
              'Income Tax: ${formatter.format(calculation.tax)} ETB',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontSize: 18,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            Text(
              'Pension: ${formatter.format(calculation.pension)} ETB',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontSize: 18,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class InputFormatter extends TextInputFormatter {
  final NumberFormat _formatter = NumberFormat('#,##0.##');

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Allow clearing
    if (newValue.text.isEmpty) {
      return newValue;
    }

    // Remove commas
    final newText = newValue.text.replaceAll(',', '');

    // Parse
    final number = double.tryParse(newText);
    if (number == null) {
      return oldValue;
    }

    final formatted = _formatter.format(number);

    // ---- CURSOR CALCULATION ----
    final oldSelectionIndex = oldValue.selection.end;

    // Count commas before cursor in old & new text
    int oldCommasBeforeCursor = _countCommas(
      oldValue.text.substring(
        0,
        oldSelectionIndex.clamp(0, oldValue.text.length),
      ),
    );

    int newCommasBeforeCursor = _countCommas(
      formatted.substring(0, _min(formatted.length, newValue.selection.end)),
    );

    final cursorOffset =
        newValue.selection.end +
        (newCommasBeforeCursor - oldCommasBeforeCursor);

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(
        offset: cursorOffset.clamp(0, formatted.length),
      ),
    );
  }

  int _countCommas(String text) => ','.allMatches(text).length;

  int _min(int a, int b) => a < b ? a : b;
}
