// lib/screens/home_screen.dart

import 'package:flutter/material.dart';
import 'calculator_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'CayoCalc',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Logo centrado
              Padding(
                padding: const EdgeInsets.only(bottom: 32),
                child: Image.asset(
                  'assets/Cayocalc.png',
                  height: 220,
                  fit: BoxFit.contain,
                ),
              ),
              Text(
                'Optimize your Cayo Perico loot',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Colors.white70,
                    ),
              ),
              const SizedBox(height: 32),
              // Botón cuadrado estilo Cayo Perico (naranja arriba, negro abajo)
              Center(
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => const CalculatorScreen()),
                    );
                  },
                  child: IntrinsicHeight(
                    child: Container(
                      width: 220,
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xFFFF6600), width: 2),
                        borderRadius: BorderRadius.zero,
                        color: Colors.black,
                      ),
                      child: Column(
                        children: [
                          Container(
                            width: 220,
                            color: const Color(0xFFFF6600),
                            alignment: Alignment.center,
                            child: const SizedBox(
                              height: 48,
                              child: Center(
                                child: Text(
                                  'START',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 22,
                                    letterSpacing: 1.5,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            width: 220,
                            color: Colors.black,
                            alignment: Alignment.center,
                            child: const SizedBox(
                              height: 48,
                              child: Center(
                                child: Text(
                                  '\$\$\$', // $$$
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 28,
                                    letterSpacing: 2,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}