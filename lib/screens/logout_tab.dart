import 'package:flutter/material.dart';
import 'package:get/get.dart'; // Import Get untuk navigasi
import '../utils/styles.dart'; // Import styles.dart

class LogoutTab extends StatefulWidget {
  const LogoutTab({super.key});

  @override
  State<LogoutTab> createState() => _LogoutTabState();
}

class _LogoutTabState extends State<LogoutTab> {
  Future<void> _logout() async {

    if (mounted) {
      // Navigasi ke halaman utama atau login dan menghapus semua route sebelumnya
      Get.offAllNamed('/'); // Pastikan route '/' sudah terdaftar sebagai halaman utama atau login
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: _logout,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Text(
            'LOGOUT',
            style: TextStyles.bodywhite,
          ),
        ),
      ),
    );
  }
}
