// lib/screens/results_screen.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../logic/heist_optimizer.dart';

class ResultsScreen extends StatefulWidget {
  final HeistResult result;

  const ResultsScreen({super.key, required this.result});

  @override
  State<ResultsScreen> createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen> {
  // Declared here, will be initialized in initState.
  late List<bool> _isPanelExpanded;

  // A helper for formatting numbers as currency.
  final currencyFormatter =
      NumberFormat.currency(locale: 'en_US', symbol: '\$', decimalDigits: 0);

  @override
  void initState() {
    super.initState();
    // Initialize the list with the correct length based on the actual number of players.
    _isPanelExpanded =
        List.generate(widget.result.playerResults.length, (_) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Heist Report'),
        // TODO: Add a Share button here later
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildSummaryCard(),
          const SizedBox(height: 24),
          Text('Player Distribution',
              style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          _buildPlayerDistributionPanels(),
        ],
      ),
    );
  }

  Widget _buildSummaryCard() {
    return Card(
      color: Colors.black26,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'TOTAL TAKE (After Pavel\'s Cut)',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(color: Colors.white70),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              currencyFormatter.format(widget.result.finalTake),
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _summaryInfo('Take Per Player',
                    currencyFormatter.format(widget.result.takePerPlayer)),
                _summaryInfo('Primary Target',
                    currencyFormatter.format(widget.result.primaryLootValue)),
                _summaryInfo('Secondary Loot',
                    currencyFormatter.format(widget.result.secondaryLootValue)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _summaryInfo(String title, String value) {
    return Column(
      children: [
        Text(title,
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: Colors.white70)),
        const SizedBox(height: 4),
        Text(value, style: Theme.of(context).textTheme.titleLarge),
      ],
    );
  }

  Widget _buildPlayerDistributionPanels() {
    // Convert the map entries to a list to be able to access by a numeric index.
    final playerEntries = widget.result.playerResults.entries.toList();

    return ExpansionPanelList(
      expansionCallback: (int panelIndex, bool isExpanded) {
        // This function receives the index of the panel that was tapped (0, 1, 2...).
        setState(() {
          // We update the state at the same index position. Now they match!
          _isPanelExpanded[panelIndex] = !isExpanded;
        });
      },
      children: List.generate(playerEntries.length, (int itemIndex) {
        // We use List.generate to have a clear index (0, 1, 2...) for each panel.
        final playerNumber = playerEntries[itemIndex].key;
        final playerResult = playerEntries[itemIndex].value;

        return ExpansionPanel(
          // We tell the panel that its state (expanded/collapsed) is at the 'itemIndex' position.
          isExpanded: _isPanelExpanded[itemIndex],
          backgroundColor: const Color(0xFF2C3E50),
          headerBuilder: (BuildContext context, bool isExpanded) {
            return ListTile(
              title: Text(
                'Player $playerNumber',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              trailing: Text(
                currencyFormatter.format(playerResult.secondaryValue),
                style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold),
              ),
            );
          },
          body: Padding(
            padding:
                const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: playerResult.itemStrings
                    .map((item) =>
                        Text('• $item', style: const TextStyle(height: 1.5)))
                    .toList(),
              ),
            ),
          ),
        );
      }),
    );
  }
}