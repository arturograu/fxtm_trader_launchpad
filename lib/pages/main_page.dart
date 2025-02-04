import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fxtm/services/forex_rate_service.dart';

import '../models/forex_pair.dart';
import '../repositories/forex_repository.dart';
import '../services/finnhub_service.dart';
import 'history_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;
  late ForexRepository _forexRepository;
  List<ForexPair> _forexPairs = [];
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _forexRepository = ForexRepository(
      finnhubService: FinnhubServiceImpl(
        apiKey: dotenv.env['FINHUB_API_KEY'] ?? '',
      ),
      forexRateService: ForexRateServiceImpl(
        apiKey: dotenv.env['FOREX_RATE_API_KEY'] ?? '',
      ),
    );
    _initialize();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _initialize() async {
    try {
      final pairs = await _forexRepository.getForexPairs();
      setState(() {
        _forexPairs = pairs;
      });
      _forexRepository.subscribeToForexTrades(
          _forexPairs.map((pair) => pair.symbol).toList());
      _forexRepository.forexPairs.listen((pairs) {
        setState(() {
          _forexPairs = pairs;
        });
      });
    } catch (e) {
      // Handle error
    }
  }

  void _onItemTapped(int index) {
    if (index == 0) {
      setState(() {
        _selectedIndex = index;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('This menu item is disabled')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FXTM Forex Tracker'),
      ),
      body: _buildBody(),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Markets',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.newspaper),
            label: 'News',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _buildBody() {
    if (_forexPairs.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    } else {
      return ListView.separated(
        itemCount: _forexPairs.length,
        separatorBuilder: (context, index) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final pair = _forexPairs[index];
          final isPriceUp = pair.change >= 0;
          final arrowIcon =
              isPriceUp ? Icons.arrow_upward : Icons.arrow_downward;
          final arrowColor = isPriceUp ? Colors.green : Colors.red;

          return ListTile(
            leading: Icon(arrowIcon, color: arrowColor),
            title: Text(
              pair.symbol,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            subtitle: Text(
              'Price: ${pair.currentPrice.toStringAsFixed(4)}',
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${pair.change >= 0 ? '+' : ''}${pair.change.toStringAsFixed(4)}',
                  style: TextStyle(
                    color: arrowColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  '${pair.percentChange >= 0 ? '+' : ''}${pair.percentChange.toStringAsFixed(2)}%',
                  style: TextStyle(
                    color: arrowColor,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HistoryPage(forexPair: pair),
                ),
              );
            },
          );
        },
      );
    }
  }
}
