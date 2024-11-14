import 'package:flutter/material.dart';
import '../utils/styles.dart';

class TemperatureScreen extends StatefulWidget {
  const TemperatureScreen({super.key});

  @override
  State<TemperatureScreen> createState() => _TemperatureScreenState();
}

class _TemperatureScreenState extends State<TemperatureScreen> {
  final TextEditingController _inputController = TextEditingController();
  double _celsius = 0;
  double _fahrenheit = 32;
  double _kelvin = 273.15;
  String _selectedUnit = 'Celsius';

  void _convertTemperature(String value) {
    if (value.isEmpty) {
      setState(() {
        _celsius = 0;
        _fahrenheit = 32;
        _kelvin = 273.15;
      });
      return;
    }

    double input = double.tryParse(value) ?? 0;

    setState(() {
      switch (_selectedUnit) {
        case 'Celsius':
          _celsius = input;
          _fahrenheit = (input * 9 / 5) + 32;
          _kelvin = input + 273.15;
          break;
        case 'Fahrenheit':
          _fahrenheit = input;
          _celsius = (input - 32) * 5 / 9;
          _kelvin = (input - 32) * 5 / 9 + 273.15;
          break;
        case 'Kelvin':
          _kelvin = input;
          _celsius = input - 273.15;
          _fahrenheit = (input - 273.15) * 9 / 5 + 32;
          break;
      }
    });
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
        title: Text('Temperature Conversion', style: TextStyles.titlewhite),
        backgroundColor: AppColors.arsenalblack,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _inputController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Input Temperature Value',
                  labelStyle: TextStyles.body,
                  border: OutlineInputBorder(),
                ),
                onChanged: _convertTemperature,
              ),
              const SizedBox(height: 20),
              DropdownButton<String>(
                value: _selectedUnit,
                isExpanded: true,
                items: ['Celsius', 'Fahrenheit', 'Kelvin']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value, style: TextStyles.body),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedUnit = newValue!;
                    _convertTemperature(_inputController.text);
                  });
                },
              ),
              const SizedBox(height: 40),
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text('Conversion Result:', style: TextStyles.title),
                      const SizedBox(height: 20),
                      _buildResultRow('Celsius', _celsius, '°C'),
                      const Divider(),
                      _buildResultRow('Fahrenheit', _fahrenheit, '°F'),
                      const Divider(),
                      _buildResultRow('Kelvin', _kelvin, 'K'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResultRow(String label, double value, String unit) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyles.body),
          Text(
            '${value.toStringAsFixed(2)} $unit',
            style: TextStyles.body,
          ),
        ],
      ),
    );
  }
}
