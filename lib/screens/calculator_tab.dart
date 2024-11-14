import 'package:flutter/material.dart';
import '../utils/styles.dart'; // Adjust this import path based on your project structure

class CalculatorTab extends StatefulWidget {
  const CalculatorTab({super.key});
  @override
  State<CalculatorTab> createState() => _CalculatorTabState();
}

class _CalculatorTabState extends State<CalculatorTab> {
  String _display = '0';
  String _history = '';
  double _firstNumber = 0;
  String _operator = '';
  bool _shouldResetDisplay = false;
  bool _hasDecimal = false;

  final List<List<dynamic>> _buttons = [
    ['C', '⌫', '%', '÷'],
    ['7', '8', '9', '×'],
    ['4', '5', '6', '-'],
    ['1', '2', '3', '+'],
    ['±', '0', '.', '='],
  ];

  Color _getButtonColor(String value) {
    if (value == '=' || value == '⌫' || value == 'C') {
      return AppColors.arsenalblack;
    } else if (value == '÷' || value == '×' || value == '-' || value == '+' || value == '%') {
      return AppColors.arsenalblack.withOpacity(0.9);
    }
    return AppColors.arsenalblack.withOpacity(0.8);
  }

  TextStyle _getButtonTextStyle(String value) {
    if (['+', '-', '×', '÷', '%', '=', 'C', '⌫'].contains(value)) {
      return TextStyles.titlewhite.copyWith(fontSize: 24);
    }
    return TextStyles.bodywhite.copyWith(fontSize: 24);
  }

  void _updateDisplay(String value) {
    setState(() {
      if (value == '.') {
        if (!_hasDecimal) {
          _display = _shouldResetDisplay ? '0.' : '$_display.';
          _hasDecimal = true;
          _shouldResetDisplay = false;
        }
        return;
      }

      if (_display == '0' || _shouldResetDisplay) {
        _display = value;
        _shouldResetDisplay = false;
      } else {
        _display += value;
      }
    });
  }

  void _setOperator(String operator) {
    setState(() {
      _firstNumber = double.parse(_display);
      _operator = operator;
      _shouldResetDisplay = true;
      _hasDecimal = false;
      _history = '$_display $operator';
    });
  }

  void _calculateResult() {
    setState(() {
      double secondNumber = double.parse(_display);
      double result;

      _history += ' $_display =';

      switch (_operator) {
        case '+':
          result = _firstNumber + secondNumber;
          break;
        case '-':
          result = _firstNumber - secondNumber;
          break;
        case '×':
          result = _firstNumber * secondNumber;
          break;
        case '÷':
          result = secondNumber != 0 ? _firstNumber / secondNumber : double.infinity;
          break;
        case '%':
          result = _firstNumber % secondNumber;
          break;
        default:
          result = secondNumber;
          break;
      }

      String resultString = result.toString();
      if (resultString.contains('.')) {
        resultString = resultString.replaceAll(RegExp(r'\.?0*$'), '');
      }

      _display = resultString;
      _operator = '';
      _shouldResetDisplay = true;
      _hasDecimal = _display.contains('.');
    });
  }

  void _clearDisplay() {
    setState(() {
      _display = '0';
      _history = '';
      _firstNumber = 0;
      _operator = '';
      _shouldResetDisplay = false;
      _hasDecimal = false;
    });
  }

  void _handleBackspace() {
    setState(() {
      if (_display.length > 1) {
        if (_display[_display.length - 1] == '.') {
          _hasDecimal = false;
        }
        _display = _display.substring(0, _display.length - 1);
      } else {
        _display = '0';
      }
    });
  }

  void _toggleSign() {
    setState(() {
      if (_display != '0') {
        if (_display.startsWith('-')) {
          _display = _display.substring(1);
        } else {
          _display = '-$_display';
        }
      }
    });
  }

  void _handleButtonPress(String value) {
    if (value == 'C') {
      _clearDisplay();
    } else if (value == '⌫') {
      _handleBackspace();
    } else if (value == '±') {
      _toggleSign();
    } else if (value == '=' && _operator.isNotEmpty) {
      _calculateResult();
    } else if (['+', '-', '×', '÷', '%'].contains(value)) {
      _setOperator(value);
    } else {
      _updateDisplay(value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                alignment: Alignment.topRight,
                padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 12),
                child: Text(
                  _history,
                  style: TextStyles.body.copyWith(
                    fontSize: 20,
                    color: AppColors.arsenalblack.withOpacity(0.6),
                  ),
                ),
              ),
              Container(
                alignment: Alignment.bottomRight,
                padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 12),
                child: Text(
                  _display,
                  style: TextStyles.title.copyWith(fontSize: 48),
                ),
              ),
              const SizedBox(height: 20),
              ...List.generate(
                _buttons.length,
                    (i) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(
                      _buttons[i].length,
                          (j) => SizedBox(
                        width: 75,
                        height: 75,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _getButtonColor(_buttons[i][j]),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 2,
                            padding: const EdgeInsets.all(16),
                          ),
                          onPressed: () => _handleButtonPress(_buttons[i][j]),
                          child: Text(
                            _buttons[i][j],
                            style: _getButtonTextStyle(_buttons[i][j]),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
