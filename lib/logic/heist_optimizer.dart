// lib/logic/heist_optimizer.dart

import 'dart:math';
import 'package:cayocalc/models/heist_data.dart';

// --- Input/Output classes for clean architecture ---
class HeistInput {
  final int playerCount;
  final PrimaryLoot primaryLoot;
  final bool isHardMode;
  final Map<SecondaryLoot, int> availableLoot;

  HeistInput({
    required this.playerCount,
    required this.primaryLoot,
    required this.isHardMode,
    required this.availableLoot,
  });
}


class PlayerLootShare {
  final String name;
  final double percent; // 0.0 a 1.0
  final double value;

  PlayerLootShare({required this.name, required this.percent, required this.value});
}

class PlayerResult {
  final List<PlayerLootShare> lootShares;
  final double secondaryValue;

  PlayerResult({required this.lootShares, required this.secondaryValue});
}

class HeistResult {
  final String primaryLootName;
  final int primaryLootValue;
  final int secondaryLootValue;
  final int totalLootValue; // Before Pavel's cut
  final int finalTake; // After Pavel's cut
  final int takePerPlayer;
  final Map<int, PlayerResult> playerResults;

  HeistResult({
    required this.primaryLootName,
    required this.primaryLootValue,
    required this.secondaryLootValue,
    required this.totalLootValue,
    required this.finalTake,
    required this.takePerPlayer,
    required this.playerResults,
  });
}

// --- Main Optimizer Logic ---
class HeistOptimizer {
  HeistResult calculateOptimalLoot(HeistInput input) {
    // --- Data Preparation ---
    final primaryTargetData = GameData.primaryLootData[input.primaryLoot]!;
    int primaryValue =
        (primaryTargetData.value * (input.isHardMode ? 1.1 : 1.0)).round();

    List<LootItem> allAvailableLoot = [];
    input.availableLoot.forEach((lootType, count) {
      final lootData = GameData.secondaryLootData[lootType]!;
      for (int i = 0; i < count; i++) {
        allAvailableLoot.add(lootData);
      }
    });

    // --- PHASE 1: Knapsack for indivisible loot ---

    final double totalCapacity = (100.0 * input.playerCount);
    final indivisibleLoot = allAvailableLoot.where((item) => !item.isDivisible).toList();
    final n = indivisibleLoot.length;
    var k = List.generate(n + 1, (i) => List.filled(totalCapacity.toInt() + 1, 0));

    for (int i = 1; i <= n; i++) {
      for (int w = 1; w <= totalCapacity; w++) {
        final item = indivisibleLoot[i - 1];
        if (item.percentage <= w) {
          k[i][w] = max(item.value + k[i - 1][w - item.percentage.toInt()], k[i - 1][w]);
        } else {
          k[i][w] = k[i - 1][w];
        }
      }
    }

    List<LootItem> mainLoot = [];
    double w = totalCapacity;
    for (int i = n; i > 0 && w > 0; i--) {
      if (k[i][w.toInt()] != k[i - 1][w.toInt()]) {
        final item = indivisibleLoot[i - 1];
        mainLoot.add(item);
        w -= item.percentage;
      }
    }

    // --- PHASE 2: Distribution of main loot ---
    mainLoot.sort((a, b) => b.percentage.compareTo(a.percentage));
    var playerCapacities = List.filled(input.playerCount, 100.0);

    var distribution = <int, Map<String, dynamic>>{};
    for (int i = 0; i < input.playerCount; i++) {
      distribution[i] = {'lootShares': <PlayerLootShare>[], 'value': 0.0};
    }

    for (final item in mainLoot) {
      for (int i = 0; i < input.playerCount; i++) {
        if (playerCapacities[i] >= item.percentage) {
          distribution[i]!['lootShares'].add(PlayerLootShare(
            name: item.name,
            percent: item.percentage / 100.0,
            value: item.value.toDouble(),
          ));
          distribution[i]!['value'] += item.value;
          playerCapacities[i] -= item.percentage;
          break;
        }
      }
    }

    // --- PHASE 3: Fill with divisible loot ---
    
    final divisibleLootPool = allAvailableLoot.where((item) => item.isDivisible).toList();
    var availableResources = <String, Map<String, dynamic>>{};
    for (final item in divisibleLootPool) {
      if (!availableResources.containsKey(item.name)) {
        availableResources[item.name] = {'total_weight': 0.0, 'value_per_pct': item.efficiency};
      }
      availableResources[item.name]!['total_weight'] += item.percentage;
    }

    for (int i = 0; i < input.playerCount; i++) {
      double spaceToFill = playerCapacities[i];
      while (spaceToFill > 0) {
        String? bestResourceName;
        double maxEfficiency = -1;
        availableResources.forEach((name, data) {
          if (data['total_weight'] > 0 && data['value_per_pct'] > maxEfficiency) {
            maxEfficiency = data['value_per_pct'];
            bestResourceName = name;
          }
        });

        if (bestResourceName == null) {
          break;
        }

        final resource = availableResources[bestResourceName!]!;
        final weightToTake = min(spaceToFill, resource['total_weight']);
        distribution[i]!['lootShares'].add(PlayerLootShare(
          name: bestResourceName!,
          percent: weightToTake / 100.0,
          value: weightToTake * resource['value_per_pct'],
        ));
        distribution[i]!['value'] += weightToTake * resource['value_per_pct'];
        resource['total_weight'] -= weightToTake;
        spaceToFill -= weightToTake;
      }
    }

    // --- Final Report Generation ---

    double totalSecondaryValue = 0;
    Map<int, PlayerResult> finalPlayerResults = {};
    for (int i = 0; i < input.playerCount; i++) {
      totalSecondaryValue += distribution[i]!['value'];
      finalPlayerResults[i + 1] = PlayerResult(
        lootShares: List<PlayerLootShare>.from(distribution[i]!['lootShares']),
        secondaryValue: distribution[i]!['value'],
      );
    }

    final totalLootValue = primaryValue + totalSecondaryValue;
    final finalTake = totalLootValue * 0.88; // Pavel's 12% cut
    final takePerPlayer = finalTake / input.playerCount;

    return HeistResult(
      primaryLootName: primaryTargetData.name,
      primaryLootValue: primaryValue,
      secondaryLootValue: totalSecondaryValue.toInt(),
      totalLootValue: totalLootValue.toInt(),
      finalTake: finalTake.toInt(),
      takePerPlayer: takePerPlayer.toInt(),
      playerResults: finalPlayerResults,
    );
  }
}