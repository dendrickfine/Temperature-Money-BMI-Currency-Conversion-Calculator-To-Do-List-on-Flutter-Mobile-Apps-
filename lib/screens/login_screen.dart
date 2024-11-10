import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import 'nav.dart';
import 'signup_screen.dart';
import 'package:myarsenal/utils/styles.dart';
import 'package:myarsenal/widget/custom_textfield.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isObscure = true;
  String errorMessage = ''; // Untuk menampilkan pesan error

  Future<void> login() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final storedEmail = prefs.getString('email');
    final storedPassword = prefs.getString('password');
    final storedUsername = prefs.getString('username');

    // Validasi login
    if (emailController.text == storedEmail &&
        passwordController.text == storedPassword) {
      setState(() {
        errorMessage = ''; // Kosongkan pesan error jika login berhasil
      });

      // Cek apakah widget masih terpasang sebelum navigasi
      if (mounted) {
        // Transisi zoom out menuju halaman HomeScreen di nav.dart
        Get.to(
          HomeScreen(username: storedUsername ?? 'User'),
          transition: Transition.zoom, // Animasi zoom out saat berpindah halaman
          duration: const Duration(milliseconds: 500), // Durasi animasi
        );
      }
    } else {
      setState(() {
        errorMessage = 'Invalid email or password!'; // Tampilkan pesan error
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Login Dunder Mifflin',
          style: TextStyles.title,
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Image.asset('assets/images/dmi.png'),
              const SizedBox(height: 24.0),
              Text(
                'Login Office',
                style: TextStyles.title.copyWith(fontSize: 20.0),
              ),
              const SizedBox(height: 20.0),
              CustomTextfield(
                controller: emailController,
                textInputType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                hint: 'Email',
              ),
              const SizedBox(height: 16.0),
              CustomTextfield(
                controller: passwordController,
                textInputType: TextInputType.visiblePassword,
                textInputAction: TextInputAction.done,
                hint: 'Password',
                isObscure: isObscure,
                hasSuffix: true,
                onPressed: () {
                  setState(() {
                    isObscure = !isObscure;
                  });
                },
              ),
              const SizedBox(height: 8.0),
              Text(
                errorMessage,
                style: const TextStyle(
                  color: Colors.red,
                  fontSize: 14.0,
                ),
              ),
              const SizedBox(height: 24.0),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                ),
                onPressed: login,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Text(
                    'LOGIN',
                    style: TextStyles.title.copyWith(
                      fontSize: 20.0,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24.0),
              GestureDetector(
                onTap: () {
                  Get.to(const SignupScreen()); // Ganti navigasi menjadi Get.to
                },
                child: Text(
                  'Sign Up',
                  style: TextStyles.body.copyWith(
                    fontSize: 18.0,
                    color: Colors.black,
                    decoration: TextDecoration.underline,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
