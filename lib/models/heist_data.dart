// lib/models/heist_data.dart

import 'package:flutter/foundation.dart';

// Using Enums to avoid typos and for cleaner code.
enum PrimaryLoot { tequila, necklace, bonds, diamond, panther }
enum SecondaryLoot { gold, art, cocaine, weed, cash }

@immutable
class LootItem {
  final String name;
  final int value;
  final double percentage; // Corresponds to 'peso' in the Python script
  final bool isDivisible;

  const LootItem({
    required this.name,
    required this.value,
    required this.percentage,
    this.isDivisible = false,
  });

  // 'eficiencia' or 'valor_por_pct'
  double get efficiency => value / percentage;
}

class GameData {
  // Primary Target values from the Python script
  static const Map<PrimaryLoot, LootItem> primaryLootData = {
    PrimaryLoot.tequila: LootItem(name: 'Sinsimito Tequila', value: 630000, percentage: 0),
    PrimaryLoot.necklace: LootItem(name: 'Ruby Necklace', value: 700000, percentage: 0),
    PrimaryLoot.bonds: LootItem(name: 'Bearer Bonds', value: 770000, percentage: 0),
    PrimaryLoot.diamond: LootItem(name: 'Pink Diamond', value: 1300000, percentage: 0),
    PrimaryLoot.panther: LootItem(name: 'Panther Statue', value: 1900000, percentage: 0),
  };

  // Secondary Loot values from the Python script
  static const Map<SecondaryLoot, LootItem> secondaryLootData = {
    SecondaryLoot.gold: LootItem(name: 'Gold', value: 330000, percentage: 67, isDivisible: false),
    SecondaryLoot.art: LootItem(name: 'Art', value: 185000, percentage: 50, isDivisible: false),
    SecondaryLoot.cocaine: LootItem(name: 'Cocaine', value: 220000, percentage: 50, isDivisible: true),
    SecondaryLoot.weed: LootItem(name: 'Weed', value: 145000, percentage: 34, isDivisible: true),
    SecondaryLoot.cash: LootItem(name: 'Cash', value: 90000, percentage: 25, isDivisible: true),
  };
}