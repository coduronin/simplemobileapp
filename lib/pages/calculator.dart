import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({super.key});

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  String _input = '';
  String _result = '';
  List<String> _history = [];
  bool _isNewCalculation = true;

  void _onButtonPressed(String value) {
    setState(() {
      if (value == 'C') {
        _input = '';
        _result = '';
        _isNewCalculation = true;
      } else if (value == '⌫') {
        _input =
            _input.isNotEmpty ? _input.substring(0, _input.length - 1) : '';
      } else if (value == '=') {
        _calculate();
        _isNewCalculation = true;
      } else {
        if (_isNewCalculation && !'÷×-+%.()'.contains(value)) {
          _input = '';
          _result = '';
        }
        _input += value;
        _isNewCalculation = false;
      }

      if (_input.isNotEmpty && value != '=') {
        try {
          final result = _evaluateExpression(_input);
          _result = '=${result.toStringAsFixed(2).replaceAll('.00', '')}';
        } catch (e) {
          _result = '';
        }
      } else {
        _result = '';
      }
    });
  }

  void _calculate() {
    try {
      final result = _evaluateExpression(_input);
      setState(() {
        _history.insert(0, '$_input = $result');
        _input = result.toString();
        _result = '';
      });
    } catch (e) {
      setState(() {
        _result = 'Error';
      });
    }
  }

  double _evaluateExpression(String expression) {
    try {
      final parser = Parser();
      final parsedExpression =
          parser.parse(expression.replaceAll('×', '*').replaceAll('÷', '/'));
      final result =
          parsedExpression.evaluate(EvaluationType.REAL, ContextModel());
      return result is double ? result : result.toDouble();
    } catch (e) {
      throw Exception("Invalid expression");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        backgroundColor: Colors.grey[850],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Calculator',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 3,
              child: Container(
                padding: const EdgeInsets.all(16),
                alignment: Alignment.bottomRight,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      _input,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 32,
                      ),
                    ),
                    Text(
                      _result,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: Container(
                color: Colors.grey[850],
                child: _buildCalculatorButtons(),
              ),
            ),
            Container(
              height: 80,
              color: Colors.grey[900],
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _history.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Chip(
                      label: Text(
                        _history[index],
                        style: const TextStyle(color: Colors.white),
                      ),
                      backgroundColor: Colors.grey[800],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCalculatorButtons() {
    final buttons = [
      ['C', '⌫', '%', '÷'],
      ['7', '8', '9', '×'],
      ['4', '5', '6', '-'],
      ['1', '2', '3', '+'],
      ['0', '.', '(', ')'],
      ['', '', '', '='],
    ];

    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        childAspectRatio: 1.5,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: buttons.length * buttons[0].length,
      itemBuilder: (context, index) {
        final row = index ~/ 4;
        final col = index % 4;
        final buttonText = buttons[row][col];

        if (buttonText.isEmpty) return const SizedBox.shrink();

        final isOperator = '÷×-+%=()'.contains(buttonText);
        final isClear = buttonText == 'C' || buttonText == '⌫';

        return ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: isClear
                ? Colors.red[400]
                : isOperator
                    ? Colors.blue[400]
                    : Colors.grey[800],
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(0),
          ),
          onPressed: () => _onButtonPressed(buttonText),
          child: Text(
            buttonText,
            style: const TextStyle(fontSize: 20),
          ),
        );
      },
    );
  }
}
