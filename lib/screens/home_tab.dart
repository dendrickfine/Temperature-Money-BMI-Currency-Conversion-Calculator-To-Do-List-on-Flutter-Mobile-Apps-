import 'package:flutter/material.dart';
import 'package:myarsenal/screens/calendar_screen.dart';
import '../utils/styles.dart';
import 'bmi_screen.dart';
import 'temperature_screen.dart';
import 'currency_screen.dart';

class HomeTab extends StatelessWidget {
  final String username;

  const HomeTab({super.key, required this.username});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: size.height * 0.01),
            Center(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.arsenalblack.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: ClipRRect(
                  child: Image.asset(
                    'assets/images/theoffice.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            SizedBox(height: size.height * 0.02),
            Center(
                child: Text(
                  'Welcome Home, $username!',
                  style: TextStyles.title.copyWith(
                    fontSize: 24.0,
                  ),
                ),
              ),
            SizedBox(height: size.height * 0.03),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 0.85,
              children: [
                _buildQuickActionCard(
                  context,
                  'Body Mass Index',
                  Icons.accessibility_new,
                  const BmiScreen(),
                  'Calculate your BMI',
                ),
                _buildQuickActionCard(
                  context,
                  'Temperature',
                  Icons.thermostat,
                  const TemperatureScreen(),
                  'Convert temperature units',
                ),
                _buildQuickActionCard(
                  context,
                  'Currency',
                  Icons.attach_money,
                  const CurrencyScreen(),
                  'Convert currencies',
                ),
                _buildQuickActionCard(
                  context,
                  'Schedule',
                  Icons.calendar_month,
                  const CalendarScreen(),
                  'Manage your schedule',
                ),
              ],
            ),
            SizedBox(height: size.height * 0.04),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionCard(BuildContext context, String title, IconData icon,
      Widget destination, String description) {
    return InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => destination),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.arsenalblack, AppColors.arsenalblack.withOpacity(0.8)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppColors.arsenalblack.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 40,
              color: Colors.white,
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: TextStyles.titlewhite.copyWith(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                description,
                style: TextStyles.bodywhite.copyWith(
                  fontSize: 12,
                  color: Colors.white70,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}