import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../utils/styles.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 2500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.0, 0.5, curve: Curves.easeIn)),
    );

    _slideAnimation = Tween<double>(begin: 50.0, end: 0.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.3, 0.8, curve: Curves.easeOut)),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.4, 0.9, curve: Curves.easeOut)),
    );

    _controller.forward();

    Future.delayed(const Duration(seconds: 3), () {
      Get.offAllNamed('/login');
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.arsenalblack,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return FadeTransition(
              opacity: _fadeAnimation,
              child: Transform.translate(
                offset: Offset(0, _slideAnimation.value),
                child: Transform.scale(
                  scale: _scaleAnimation.value,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // App Title with gradient effect
                      Container(
                        margin: const EdgeInsets.only(bottom: 40),
                        child: ShaderMask(
                          shaderCallback: (bounds) => LinearGradient(
                            colors: [
                              Colors.white,
                              Colors.white.withOpacity(0.8),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ).createShader(bounds),
                          child: Text(
                            'DUNDER MIFFLIN',  // Your app name here
                            style: TextStyles.titlewhite.copyWith(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2,
                            ),
                          ),
                        ),
                      ),
                      // Profile picture with refined styling
                      Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white,
                            width: 3,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.white.withOpacity(0.15),
                              blurRadius: 30,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: ClipOval(
                          child: Image.asset(
                            'assets/images/foto.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(height: 50),
                      // Name with enhanced typography
                      Text(
                        'M. Dedrick Finnegan',
                        style: TextStyles.titlewhite.copyWith(
                          fontSize: 28,
                          letterSpacing: 0.5,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 12),
                      // ID with refined styling
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '152022183',
                          style: TextStyles.bodywhite.copyWith(
                            fontSize: 18,
                            letterSpacing: 3,
                            color: Colors.white.withOpacity(0.8),
                          ),
                        ),
                      ),
                      const SizedBox(height: 60),
                      // Enhanced loading indicator
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          const SizedBox(
                            width: 40,
                            height: 40,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 3,
                            ),
                          ),
                          SizedBox(
                            width: 40,
                            height: 40,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 3,
                              value: _controller.value,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
