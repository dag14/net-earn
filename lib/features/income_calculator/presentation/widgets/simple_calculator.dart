import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class SimpleCalculator extends StatefulWidget {
  final TextEditingController controller;
  final Future<double> Function(double gross)? calculateNet;

  const SimpleCalculator({
    super.key,
    required this.controller,
    this.calculateNet,
  });

  @override
  State<SimpleCalculator> createState() => _SimpleCalculatorState();
}

class _SimpleCalculatorState extends State<SimpleCalculator> {
  final NumberFormat _formatter = NumberFormat('#,##0.##');
  double? _netSalary;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
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
              style: const TextStyle(fontSize: 64),
              controller: widget.controller,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[\d.,]')),
              ],
              decoration: InputDecoration(
                fillColor: Colors.white,
                labelText: 'Enter Gross Salary (ETB)',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              // Format while typing (optional)
              onChanged: (value) {
                if (value.isEmpty) return;
                final cleanValue = value.replaceAll(',', '');
                final number = double.tryParse(cleanValue);
                if (number == null) return;

                final formatted = _formatter.format(number);
                if (formatted != value) {
                  widget.controller.value = TextEditingValue(
                    text: formatted,
                    selection: TextSelection.collapsed(
                      offset: formatted.length,
                    ),
                  );
                }
              },
              // Only calculate when editing is complete
              onEditingComplete: () async {
                final rawText = widget.controller.text.replaceAll(',', '');
                final gross = double.tryParse(rawText) ?? 0;

                double net = 0;
                if (widget.calculateNet != null) {
                  net = await widget.calculateNet!(gross);
                }

                setState(() {
                  _netSalary = net;
                });

                // Dismiss keyboard
                FocusScope.of(context).unfocus();
              },
            ),
            const SizedBox(height: 24),
            if (_netSalary != null)
              Text(
                'Net Salary: ${_formatter.format(_netSalary)} ETB',
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
