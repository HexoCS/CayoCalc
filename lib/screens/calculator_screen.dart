// lib/screens/calculator_screen.dart

import 'package:flutter/material.dart';
import 'package:cayocalc/models/heist_data.dart'; // Import our data models
import 'package:cayocalc/logic/heist_optimizer.dart';
import 'results_screen.dart';


class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  // State variables to hold user's selections
  int _playerCount = 1;
  PrimaryLoot _selectedPrimary = PrimaryLoot.tequila;
  bool _isHardMode = false;
  
  // Use a map to store the count for each secondary loot type
  final Map<SecondaryLoot, int> _secondaryLootCounts = {
    SecondaryLoot.gold: 0,
    SecondaryLoot.art: 0,
    SecondaryLoot.cocaine: 0,
    SecondaryLoot.weed: 0,
    SecondaryLoot.cash: 0,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Heist Setup'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // --- Player Count Section ---
          Text('Team', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          SegmentedButton<int>(
            segments: const [
              ButtonSegment(value: 1, label: Text('1')),
              ButtonSegment(value: 2, label: Text('2')),
              ButtonSegment(value: 3, label: Text('3')),
              ButtonSegment(value: 4, label: Text('4')),
            ],
            selected: {_playerCount},
            onSelectionChanged: (Set<int> newSelection) {
              setState(() {
                _playerCount = newSelection.first;
              });
            },
          ),
          const SizedBox(height: 24),

          // --- Primary Target Section ---
          Text('Primary Target', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          DropdownButtonFormField<PrimaryLoot>(
            value: _selectedPrimary,
            items: PrimaryLoot.values.map((loot) {
              return DropdownMenuItem(
                value: loot,
                child: Text(GameData.primaryLootData[loot]!.name),
              );
            }).toList(),
            onChanged: (PrimaryLoot? newValue) {
              if (newValue != null) {
                setState(() {
                  _selectedPrimary = newValue;
                });
              }
            },
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
            ),
          ),
          SwitchListTile(
            title: const Text('Hard Mode'),
            value: _isHardMode,
            onChanged: (bool value) {
              setState(() {
                _isHardMode = value;
              });
            },
          ),
          const SizedBox(height: 24),
          
          // --- Secondary Loot Section ---
          Text('Available Secondary Loot', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          ...SecondaryLoot.values.map((loot) => _buildLootStepper(loot)).toList(),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
  // 1. Create the input object from the user's selections
          final heistInput = HeistInput(
            playerCount: _playerCount,
            primaryLoot: _selectedPrimary,
            isHardMode: _isHardMode,
            availableLoot: _secondaryLootCounts,
          );

          // 2. Instantiate the optimizer and run the calculation
          final optimizer = HeistOptimizer();
          final heistResult = optimizer.calculateOptimalLoot(heistInput);

          // 3. Navigate to the results screen, passing the result object
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => ResultsScreen(result: heistResult),
            ),
          );
        },
        label: const Text('CALCULATE'),
        icon: const Icon(Icons.arrow_forward),
      ),
    );
  }

  // Helper widget to build a row for each secondary loot item
  Widget _buildLootStepper(SecondaryLoot loot) {
    final lootData = GameData.secondaryLootData[loot]!;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(lootData.name, style: const TextStyle(fontSize: 16)),
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.remove_circle_outline),
              onPressed: () {
                setState(() {
                  if (_secondaryLootCounts[loot]! > 0) {
                    _secondaryLootCounts[loot] = _secondaryLootCounts[loot]! - 1;
                  }
                });
              },
            ),
            Text(_secondaryLootCounts[loot].toString(), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            IconButton(
              icon: const Icon(Icons.add_circle_outline),
              onPressed: () {
                setState(() {
                  _secondaryLootCounts[loot] = _secondaryLootCounts[loot]! + 1;
                });
              },
            ),
          ],
        ),
      ],
    );
  }
}