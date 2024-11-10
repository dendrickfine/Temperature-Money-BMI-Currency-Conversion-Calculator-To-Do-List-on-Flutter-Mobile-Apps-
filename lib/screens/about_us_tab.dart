import 'package:flutter/material.dart';
import '../utils/styles.dart';

class AboutUsTab extends StatelessWidget {
  const AboutUsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'We are Dunder Mifflin!\n\nCreated by\n152022183 Mohamad Dedrick\n\nInspired by\nMichael Scott',
        textAlign: TextAlign.center,
        style: TextStyles.body.copyWith(
          fontSize: 24.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
