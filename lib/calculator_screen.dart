import 'package:flutter/material.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});
  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  final firstNumberController = TextEditingController();
  final secondNumberController = TextEditingController();
  String result = '0';
  String operationLabel = 'Enter two numbers';
  void calculate(String operation) {
    final first = double.tryParse(firstNumberController.text.trim());
    final second = double.tryParse(secondNumberController.text.trim());
    if (first == null ||
        second == null ||
        !first.isFinite ||
        !second.isFinite) {
      setState(() {
        result = 'Invalid input';
        operationLabel = 'Please enter two valid numbers';
      });
      return;
    }
    if (operation == '÷' && second == 0) {
      setState(() {
        result = 'Cannot divide by zero';
        operationLabel = 'Please change the second number';
      });
      return;
    }
    final double answer;
    switch (operation) {
      case '+':
        answer = first + second;
        break;
      case '-':
        answer = first - second;
        break;
      case '×':
        answer = first * second;
        break;
      case '÷':
        answer = first / second;
        break;
      default:
        return;
    }
    setState(() {
      result = answer.toString();
      operationLabel = '$first $operation $second';
    });
  }

  void clearCalculator() {
    firstNumberController.clear();
    secondNumberController.clear();
    setState(() {
      result = '0';
      operationLabel = 'Enter two numbers';
    });
  }

  @override
  void dispose() {
    firstNumberController.dispose();
    secondNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Calculator')),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(operationLabel),
              Text(result, style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 24),
              TextField(
                controller: firstNumberController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                  signed: true,
                ),
                decoration: const InputDecoration(
                  labelText: 'First number',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: secondNumberController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                  signed: true,
                ),
                decoration: const InputDecoration(
                  labelText: 'Second number',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),
              Wrap(
                spacing: 12,
                children: [
                  for (final operation in ['+', '-', '×', '÷'])
                    FilledButton(
                      onPressed: () => calculate(operation),
                      child: Text(operation),
                    ),
                ],
              ),
              TextButton(
                  onPressed: clearCalculator, child: const Text('Clear')),
            ],
          ),
        ),
      );
}
