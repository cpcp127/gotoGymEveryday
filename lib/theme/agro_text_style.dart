import 'dart:ui';

import 'package:flutter/material.dart';

class AgroTextStyle {
  AgroTextStyle._();

  static final TextStyle headlineLarge = TextStyle(
    fontWeight: FontWeight.w700,
    fontSize: 32,
    height: 40 / 32,
    color: Colors.black,
  );

  static final TextStyle headMediumLarge = TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 28,
    height: 36 / 28,
    color: Colors.black,
  );

  static final TextStyle headlineSmall = TextStyle(
    fontWeight: FontWeight.w300,
    fontSize: 24,
    height: 32 / 24,
    color: Colors.black,
  );

  static final TextStyle titleLarge = TextStyle(
    fontWeight: FontWeight.w700,
    fontSize: 28,
    height: 32 / 28,
    color: Colors.black,
  );

  static final TextStyle titleMedium = TextStyle(
      fontWeight: FontWeight.w500,
      fontSize: 16,
      height: 24 / 16,
      color: Colors.black,
      letterSpacing: -0.15);

  static final TextStyle titleSmall = TextStyle(
      fontWeight: FontWeight.w300,
      fontSize: 14,
      height: 20 / 14,
      color: Colors.black,
      letterSpacing: -0.1);

  static final TextStyle labelLarge = TextStyle(
      fontWeight: FontWeight.w700,
      fontSize: 14,
      height: 20 / 14,
      color: Colors.black,
      letterSpacing: -0.1);

  static final TextStyle labelMedium = TextStyle(
      fontWeight: FontWeight.w500,
      fontSize: 12,
      height: 16 / 12,
      color: Colors.black,
      letterSpacing: -0.5);

  static final TextStyle labelSmall = TextStyle(
      fontWeight: FontWeight.w300,
      fontSize: 11,
      height: 16 / 11,
      color: Colors.black,
      letterSpacing: -0.5);

  static final TextStyle bodyLarge = TextStyle(
      fontWeight: FontWeight.w700,
      fontSize: 16,
      height: 24 / 16,
      color: Colors.black,
      letterSpacing: -0.5);

  static final TextStyle bodyMedium = TextStyle(
      fontWeight: FontWeight.w500,
      fontSize: 14,
      height: 20 / 14,
      color: Colors.black,
      letterSpacing: -0.25);

  static final TextStyle bodySmall = TextStyle(
      fontWeight: FontWeight.w300,
      fontSize: 12,
      height: 16 / 12,
      color: Colors.black,
      letterSpacing: -0.4);
}
