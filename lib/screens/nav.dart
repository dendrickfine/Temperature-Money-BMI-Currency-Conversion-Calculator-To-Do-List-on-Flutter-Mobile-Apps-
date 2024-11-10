// nav.dart
import 'package:flutter/material.dart';
import '../utils/styles.dart';
import 'home_tab.dart';
import 'about_us_tab.dart';
import 'logout_tab.dart';
import 'calculator_tab.dart'; // Import halaman kalkulator

class HomeScreen extends StatefulWidget {
  final String username;

  const HomeScreen({super.key, required this.username});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0; // Indeks tab aktif

  // Daftar halaman yang sesuai dengan urutan BottomNavigationBarItem
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      HomeTab(username: widget.username), // 0: Home
      const CalculatorTab(),              // 1: Calculator
      const AboutUsTab(),                 // 2: About Us
      const LogoutTab(),                  // 3: Logout
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Dunder Mifflin is a Home',
          style: TextStyles.title.copyWith(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: AppColors.arsenalblack,
        iconTheme: const IconThemeData(color: Colors.white),
        automaticallyImplyLeading: false,
      ),
      body: _pages[_selectedIndex], // Tampilkan halaman sesuai tab yang dipilih
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calculate),
            label: 'Calculator',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info),
            label: 'About Us',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.logout),
            label: 'Logout',
          ),
        ],
        currentIndex: _selectedIndex, // Indeks tab aktif
        selectedItemColor: Colors.black, // Warna item aktif
        unselectedItemColor: AppColors.arsenalblack, // Warna item tidak aktif
        selectedLabelStyle: TextStyles.body.copyWith(
          fontWeight: FontWeight.bold,
        ),
        unselectedLabelStyle: TextStyles.body,
        onTap: _onItemTapped, // Navigasi saat tab dipilih
      ),
    );
  }
}
