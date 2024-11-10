import 'package:flutter/material.dart';
import '../utils/styles.dart';

class CurrencyScreen extends StatefulWidget {
  const CurrencyScreen({super.key});

  @override
  State<CurrencyScreen> createState() => _CurrencyScreenState();
}

class _CurrencyScreenState extends State<CurrencyScreen> {
  final TextEditingController _inputController = TextEditingController();
  String _selectedFromCurrency = 'IDR';
  String _selectedToCurrency = 'USD';
  double _result = 0;

  // Exchange rates as of a specific date (you might want to use an API for real-time rates)
  final Map<String, double> _exchangeRates = {
    'IDR': 1,
    'USD': 0.000064,
    'EUR': 0.000059,
    'JPY': 0.0097,
    'SGD': 0.000086,
    'MYR': 0.00030,
  };

  void _convertCurrency(String value) {
    if (value.isEmpty) {
      setState(() {
        _result = 0;
      });
      return;
    }

    double input = double.tryParse(value) ?? 0;
    double fromRate = _exchangeRates[_selectedFromCurrency] ?? 1;
    double toRate = _exchangeRates[_selectedToCurrency] ?? 1;

    // Convert to IDR first (base currency), then to target currency
    setState(() {
      _result = (input / fromRate) * toRate;
    });
  }

  String _formatNumber(double number) {
    if (number >= 1000000) {
      return '${(number/1000000).toStringAsFixed(2)}M';
    } else if (number >= 1000) {
      return '${(number/1000).toStringAsFixed(2)}K';
    } else {
      return number.toStringAsFixed(2);
    }
  }

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Money Convertion', style: TextStyles.titlewhite),
        backgroundColor: AppColors.arsenalblack,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _inputController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Input amount',
                labelStyle: TextStyles.body,
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.attach_money),
              ),
              onChanged: _convertCurrency,
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('From', style: TextStyles.body),
                      const SizedBox(height: 8),
                      DropdownButton<String>(
                        value: _selectedFromCurrency,
                        isExpanded: true,
                        items: _exchangeRates.keys
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value, style: TextStyles.body),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedFromCurrency = newValue!;
                            _convertCurrency(_inputController.text);
                          });
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('To', style: TextStyles.body),
                      const SizedBox(height: 8),
                      DropdownButton<String>(
                        value: _selectedToCurrency,
                        isExpanded: true,
                        items: _exchangeRates.keys
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value, style: TextStyles.body),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedToCurrency = newValue!;
                            _convertCurrency(_inputController.text);
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Convertion Result:', style: TextStyles.title),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _inputController.text.isEmpty ? '0' : _inputController.text,
                              style: TextStyles.title,
                            ),
                            Text(_selectedFromCurrency, style: TextStyles.body),
                          ],
                        ),
                        Icon(Icons.arrow_forward, color: AppColors.arsenalblack),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              _formatNumber(_result),
                              style: TextStyles.title,
                            ),
                            Text(_selectedToCurrency, style: TextStyles.body),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Exchange Rate Info:', style: TextStyles.title),
                    const SizedBox(height: 10),
                    Text(
                      '1 ${_selectedFromCurrency} = ${_formatNumber(_exchangeRates[_selectedToCurrency]! / _exchangeRates[_selectedFromCurrency]!)} ${_selectedToCurrency}',
                      style: TextStyles.body,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}