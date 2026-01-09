import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class SimpleCalculator extends StatelessWidget {
  final TextEditingController controller;
  final void Function(double)? onChanged;

  SimpleCalculator({super.key, required this.controller, this.onChanged});

  final NumberFormat _formatter = NumberFormat('#,##0.##');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
        child: Column(
          children: [
            Row(
              children: [
                Icon(Icons.payment, size: 24),
                const SizedBox(width: 8),
                Text(
                  'Gross to Net',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
            const SizedBox(height: 8),
            TextField(
              style: TextStyle(fontSize: 64),
              controller: controller,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(
                  RegExp(r'[\d.,]'),
                ), // allow 2 decimal places
              ],
              decoration: InputDecoration(
                fillColor: Colors.white,
                labelText: 'Enter Gross Salary (ETB)',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              onChanged: (value) {
                if (value.isEmpty) return;

                // Remove commas
                final cleanValue = value.replaceAll(',', '');

                final number = double.tryParse(cleanValue);
                if (number == null) return;

                final formatted = _formatter.format(number);

                // Avoid infinite loop
                if (formatted != value) {
                  controller.value = TextEditingValue(
                    text: formatted,
                    selection: TextSelection.collapsed(
                      offset: formatted.length,
                    ),
                  );
                }
                print('Formatted Value: $formatted');
              },
              onEditingComplete: () {
                final rawText = controller.text.replaceAll(',', '');
                final salary = double.tryParse(rawText) ?? 0;

                if (onChanged != null) {
                  onChanged!(salary);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
