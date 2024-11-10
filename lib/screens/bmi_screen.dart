import 'package:flutter/material.dart';
import '../utils/styles.dart';

class BmiScreen extends StatefulWidget {
  const BmiScreen({super.key});

  @override
  State<BmiScreen> createState() => _BmiScreenState();
}

class _BmiScreenState extends State<BmiScreen> {
  final _formKey = GlobalKey<FormState>();
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();
  String _gender = 'male';
  bool _isMetric = true;
  double _bmi = 0;
  String _bmiCategory = '';

  void _calculateBMI() {
    if (_formKey.currentState!.validate()) {
      double weight = double.parse(_weightController.text);
      double height = double.parse(_heightController.text);

      // Convert height to meters if in cm
      if (_isMetric) {
        height = height / 100;
      } else {
        // Convert pounds to kg and inches to meters
        weight = weight * 0.453592;
        height = height * 0.0254;
      }

      setState(() {
        _bmi = weight / (height * height);
        _bmiCategory = _getBMICategory(_bmi);
      });

      // Show result in SnackBar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Your BMI is: ${_bmi.toStringAsFixed(1)} ($_bmiCategory)',
            style: TextStyles.bodywhite,
          ),
          backgroundColor: _getBMIColor(_bmi),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  String _getBMICategory(double bmi) {
    if (bmi < 18.5) return 'Underweight';
    if (bmi < 25) return 'Normal';
    if (bmi < 30) return 'Overweight';
    return 'Obese';
  }

  Color _getBMIColor(double bmi) {
    if (bmi < 18.5) return Colors.blue;
    if (bmi < 25) return Colors.green;
    if (bmi < 30) return Colors.orange;
    return Colors.red;
  }

  @override
  void dispose() {
    _weightController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Body Mass Index', style: TextStyles.titlewhite),
        backgroundColor: AppColors.arsenalblack,
        iconTheme: const IconThemeData(color: Colors.white), // Tambahkan ini
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Select Gender:', style: TextStyles.title),
              const SizedBox(height: 8),
              Row(
                children: [
                  Radio<String>(
                    value: 'male',
                    groupValue: _gender,
                    onChanged: (value) {
                      setState(() => _gender = value!);
                    },
                  ),
                  Text('Male', style: TextStyles.body),
                  const SizedBox(width: 20),
                  Radio<String>(
                    value: 'female',
                    groupValue: _gender,
                    onChanged: (value) {
                      setState(() => _gender = value!);
                    },
                  ),
                  Text('Female', style: TextStyles.body),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Checkbox(
                    value: _isMetric,
                    onChanged: (value) {
                      setState(() => _isMetric = value!);
                      _weightController.clear();
                      _heightController.clear();
                    },
                  ),
                  Text('Use Metric System', style: TextStyles.body),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _weightController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: _isMetric ? 'Weight (kg)' : 'Weight (lbs)',
                  border: const OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter weight';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _heightController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: _isMetric ? 'Height (cm)' : 'Height (inches)',
                  border: const OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter height';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _calculateBMI,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.arsenalblack,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(
                    'Calculate BMI',
                    style: TextStyles.titlewhite,
                  ),
                ),
              ),
              if (_bmi > 0) ...[
                const SizedBox(height: 24),
                Card(
                  color: _getBMIColor(_bmi),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Text(
                          'Your BMI',
                          style: TextStyles.titlewhite,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _bmi.toStringAsFixed(1),
                          style: TextStyles.titlewhite.copyWith(fontSize: 36),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _bmiCategory,
                          style: TextStyles.bodywhite,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}