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
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // TODO: Añadir un logo o imagen temática aquí
              const Spacer(),
              Text(
                'Optimize your Cayo Perico loot',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Colors.white70,
                    ),
              ),
              const SizedBox(height: 32),
              
              ElevatedButton.icon(
                icon: const Icon(Icons.calculate),
                label: const Text('PLAN NEW HEIST'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.black,
                ),
                onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const CalculatorScreen()),
                );
              },
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}