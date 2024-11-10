import 'package:flutter/material.dart';

class AppColors {
  static const arsenalblack = Color (0XFF252525);
}

class TextStyles {
  static TextStyle title = const TextStyle(
    fontFamily: 'PlusJakarta',
    fontWeight: FontWeight.bold,
    fontSize: 18.0,
    color: AppColors.arsenalblack,
  );

  static TextStyle titlewhite = const TextStyle(
    fontFamily: 'PlusJakarta',
    fontWeight: FontWeight.bold,
    fontSize: 18.0,
    color: Colors.white,
  );

  static TextStyle body = const TextStyle(
    fontFamily: 'PlusJakarta',
    fontWeight: FontWeight.normal,
    fontSize: 16.0,
    color: AppColors.arsenalblack,
  );

  static TextStyle bodywhite = const TextStyle(
    fontFamily: 'PlusJakarta',
    fontWeight: FontWeight.bold,
    fontSize: 16.0,
    color: Colors.white,
  );

  // Tambahkan gaya baru jika diperlukan
  static TextStyle bodygrey = const TextStyle(
    fontFamily: 'PlusJakarta',
    fontWeight: FontWeight.normal,
    fontSize: 16.0,
    color: Colors.grey,
  );

  static TextStyle bodyblack = const TextStyle(
    fontFamily: 'PlusJakarta',
    fontWeight: FontWeight.normal,
    fontSize: 16.0,
    color: AppColors.arsenalblack,
  );

  static TextStyle button = const TextStyle(
    fontFamily: 'PlusJakarta',
    fontWeight: FontWeight.bold,
    fontSize: 16.0,
    color: Colors.white,
  );
}