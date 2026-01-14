import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:netearn/core/theme/app_theme.dart';
import 'package:netearn/features/income_calculator/providers/calc_providers.dart';

class SalaryCalculator extends ConsumerStatefulWidget {
  final TextEditingController controller;

  const SalaryCalculator({super.key, required this.controller});

  @override
  ConsumerState<SalaryCalculator> createState() => _SalaryCalculatorState();
}

class _SalaryCalculatorState extends ConsumerState<SalaryCalculator> {
  late final TextEditingController fuelController;
  late final TextEditingController housingController;
  late final TextEditingController mobileController;
  late final TextEditingController otherController;

  late final FocusNode grossFocusNode;
  late final FocusNode fuelFocusNode;
  late final FocusNode housingFocusNode;
  late final FocusNode mobileFocusNode;
  late final FocusNode otherFocusNode;

  @override
  void initState() {
    super.initState();
    fuelController = TextEditingController();
    housingController = TextEditingController();
    mobileController = TextEditingController();
    otherController = TextEditingController();

    grossFocusNode = FocusNode();
    fuelFocusNode = FocusNode();
    housingFocusNode = FocusNode();
    mobileFocusNode = FocusNode();
    otherFocusNode = FocusNode();
  }

  @override
  void dispose() {
    fuelController.dispose();
    housingController.dispose();
    mobileController.dispose();
    otherController.dispose();

    grossFocusNode.dispose();
    fuelFocusNode.dispose();
    housingFocusNode.dispose();
    mobileFocusNode.dispose();
    otherFocusNode.dispose();
    super.dispose();
  }

  double _parseAmount(TextEditingController controller) {
    final rawText = controller.text.replaceAll(',', '');
    return double.tryParse(rawText) ?? 0;
  }

  Future<void> _calculate() async {
    final gross = _parseAmount(widget.controller);
    final fuel = _parseAmount(fuelController);
    final housing = _parseAmount(housingController);
    final mobile = _parseAmount(mobileController);
    final other = _parseAmount(otherController);

    await ref
        .read(salaryCalculatorProvider.notifier)
        .calculate(
          gross,
          // fuelAllowance: fuel,
          // housingAllowance: housing,
          // mobileAllowance: mobile,
          // otherAllowances: other,
        );

    // Dismiss keyboard
    if (mounted) {
      FocusScope.of(context).unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    final NumberFormat formatter = NumberFormat('#,##0.##');
    final calculation = ref.watch(lastCalculationProvider);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Scrollbar(
        thumbVisibility: true,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.payment, size: 24),
                  const SizedBox(width: 8),
                  Text(
                    'Basic Salary',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Gross Salary
              _buildTextField(
                controller: widget.controller,
                label: 'Basic Salary (ETB)',
                icon: Icons.account_balance_wallet,
                focusNode: grossFocusNode,
                nextFocusNode: fuelFocusNode,
              ),
              const SizedBox(height: 16),

              // Allowances Section
              Text(
                'Allowances (Optional)',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),

              // Fuel Allowance
              _buildTextField(
                controller: fuelController,
                label: 'Fuel Allowance (ETB)',
                icon: Icons.local_gas_station,
                focusNode: fuelFocusNode,
                nextFocusNode: housingFocusNode,
              ),
              const SizedBox(height: 12),

              // Housing Allowance
              _buildTextField(
                controller: housingController,
                label: 'Housing Allowance (ETB)',
                icon: Icons.home,
                focusNode: housingFocusNode,
                nextFocusNode: mobileFocusNode,
              ),
              const SizedBox(height: 12),

              // Mobile Allowance
              _buildTextField(
                controller: mobileController,
                label: 'Mobile Airtime Allowance (ETB)',
                icon: Icons.phone_android,
                focusNode: mobileFocusNode,
                nextFocusNode: otherFocusNode,
              ),
              const SizedBox(height: 12),

              // Other Allowances
              _buildTextField(
                controller: otherController,
                label: 'Other Allowances (ETB)',
                icon: Icons.more_horiz,
                focusNode: otherFocusNode,
                isLastField: true,
              ),
              const SizedBox(height: 24),

              // Calculate Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _calculate,
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    child: Text('Calculate Net Salary'),
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // Results
              if (calculation != null) ...[
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.surfaceVariant.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Calculation Results',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      const Divider(height: 24),
                      _buildResultRow(
                        context,
                        'Net Salary',
                        formatter.format(calculation.netSalary),
                        AppTheme.success,
                        isBold: true,
                      ),
                      const SizedBox(height: 12),
                      _buildResultRow(
                        context,
                        'Income Tax',
                        formatter.format(calculation.tax),
                        AppTheme.red,
                      ),
                      const SizedBox(height: 12),
                      _buildResultRow(
                        context,
                        'Pension',
                        formatter.format(calculation.pension),
                        AppTheme.blue,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    FocusNode? focusNode,
    FocusNode? nextFocusNode,
    bool isLastField = false,
  }) {
    return TextField(
      controller: controller,
      focusNode: focusNode,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      textInputAction: isLastField
          ? TextInputAction.done
          : TextInputAction.next,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'[\d.,]')),
        InputFormatter(),
      ],
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, size: 20),
        isDense: true,
      ),
      onEditingComplete: () {
        if (isLastField) {
          _calculate();
        } else if (nextFocusNode != null) {
          FocusScope.of(context).requestFocus(nextFocusNode);
        }
      },
    );
  }

  Widget _buildResultRow(
    BuildContext context,
    String label,
    String value,
    Color color, {
    bool isBold = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            fontWeight: isBold ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
        Text(
          '$value ETB',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: color,
            fontWeight: isBold ? FontWeight.w700 : FontWeight.w600,
            fontSize: isBold ? 18 : 16,
          ),
        ),
      ],
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
