import 'package:flutter/material.dart';
import '../models/forex_pair.dart';

class HistoryPage extends StatelessWidget {
  final ForexPair forexPair;

  HistoryPage({required this.forexPair});

  @override
  Widget build(BuildContext context) {
    // Placeholder for the history graph and data
    return Scaffold(
      appBar: AppBar(
        title: Text('${forexPair.symbol} History'),
      ),
      body: Center(
        child: Text(
          'Historical data for ${forexPair.symbol} will be displayed here.',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
