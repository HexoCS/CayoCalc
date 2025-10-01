// lib/main.dart


import 'package:flutter/material.dart';
import 'package:cayocalc/screens/home_screen.dart';


void main() {
  runApp(const CayoCalcApp());
}

class CayoCalcApp extends StatelessWidget {
  const CayoCalcApp({super.key});

  @override
  Widget build(BuildContext context) {
  const orangeNeon = Color(0xFFFF6600);
  const panelBg = Color(0xFF111111);
  const borderColor = orangeNeon;
  const textColor = Colors.white;
  const fontOrbitron = 'Orbitron';

    return MaterialApp(
      title: 'CayoCalc',
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: orangeNeon,
        scaffoldBackgroundColor: Colors.black,
        fontFamily: fontOrbitron,
        textTheme: const TextTheme(
          displayLarge: TextStyle(fontFamily: fontOrbitron, color: textColor),
          displayMedium: TextStyle(fontFamily: fontOrbitron, color: textColor),
          displaySmall: TextStyle(fontFamily: fontOrbitron, color: textColor),
          headlineMedium: TextStyle(fontFamily: fontOrbitron, color: orangeNeon, fontWeight: FontWeight.bold),
          headlineSmall: TextStyle(fontFamily: fontOrbitron, color: orangeNeon, fontWeight: FontWeight.bold),
          titleLarge: TextStyle(fontFamily: fontOrbitron, color: orangeNeon, fontWeight: FontWeight.bold),
          titleMedium: TextStyle(fontFamily: fontOrbitron, color: orangeNeon, fontWeight: FontWeight.bold),
          titleSmall: TextStyle(fontFamily: fontOrbitron, color: textColor),
          bodyLarge: TextStyle(fontFamily: fontOrbitron, color: textColor),
          bodyMedium: TextStyle(fontFamily: fontOrbitron, color: textColor),
          bodySmall: TextStyle(fontFamily: fontOrbitron, color: textColor),
          labelLarge: TextStyle(fontFamily: fontOrbitron, color: orangeNeon),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          foregroundColor: orangeNeon,
          elevation: 0,
          titleTextStyle: TextStyle(fontFamily: fontOrbitron, color: orangeNeon, fontWeight: FontWeight.bold, fontSize: 22),
          iconTheme: IconThemeData(color: orangeNeon),
        ),
        cardTheme: const CardThemeData(
          color: panelBg,
          shape: RoundedRectangleBorder(
            side: BorderSide(color: borderColor, width: 2),
            borderRadius: BorderRadius.zero,
          ),
          elevation: 0,
        ),
        dividerColor: orangeNeon,
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}