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
    return MaterialApp(
      title: 'CayoCalc',
      // Definimos un tema básico con la paleta de colores de Cayo Perico
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color(0xFFF9A825), // Un amarillo dorado
        scaffoldBackgroundColor: const Color(0xFF1A2A2A), // Un verde oscuro azulado
        colorScheme: ColorScheme.fromSwatch(
          brightness: Brightness.dark,
          primarySwatch: Colors.amber,
        ).copyWith(
          secondary: const Color(0xFF81D4FA), // Un azul claro para acentos
        ),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}