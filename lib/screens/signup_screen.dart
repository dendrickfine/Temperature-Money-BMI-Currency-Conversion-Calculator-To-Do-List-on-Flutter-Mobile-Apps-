import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:myarsenal/utils/styles.dart';
import 'package:myarsenal/widget/custom_textfield.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isObscure = true;

  Future<void> saveAccount() async {
    final prefs = await SharedPreferences.getInstance();

    // Validasi untuk memastikan username dan email unik
    final existingUsername = prefs.getString('username');
    final existingEmail = prefs.getString('email');
    if (existingUsername == usernameController.text || existingEmail == emailController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Username or email already exists!',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Menyimpan data akun baru
    await prefs.setString('username', usernameController.text);
    await prefs.setString('email', emailController.text);
    await prefs.setString('password', passwordController.text);

    if (mounted) {
      // Tampilkan SnackBar setelah data tersimpan
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Account Registered Successfully!',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.green,
        ),
      );

      // Tunggu sebelum navigasi
      await Future.delayed(const Duration(seconds: 1));

      // Pastikan widget masih aktif sebelum navigasi
      if (mounted) {
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Join Dunder Mifflin',
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
              CustomTextfield(
                controller: usernameController,
                textInputType: TextInputType.text,
                textInputAction: TextInputAction.next,
                hint: 'Username',
              ),
              const SizedBox(height: 16.0),
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
              const SizedBox(height: 24.0),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                ),
                onPressed: () {
                  if (usernameController.text.isNotEmpty &&
                      emailController.text.isNotEmpty &&
                      passwordController.text.isNotEmpty) {
                    saveAccount(); // Simpan akun jika validasi benar
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Please fill in all fields',
                          style: TextStyle(color: Colors.white),
                        ),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Text(
                    'SIGN UP',
                    style: TextStyles.title.copyWith(
                      fontSize: 20.0,
                      color: Colors.white,
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

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
