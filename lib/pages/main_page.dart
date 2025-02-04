import 'dart:async';
import 'package:flutter/material.dart';
import '../models/forex_pair.dart';
import '../repositories/forex_repository.dart';
import '../services/finnhub_service.dart';
import 'history_page.dart';

class MainPage extends StatefulWidget {
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
    _forexRepository = ForexRepository(FinnhubServiceImpl());
    _loadForexPairs();

    // Simulate real-time price updates every 5 seconds
    _timer = Timer.periodic(Duration(seconds: 5), (timer) {
      _updatePrices();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _loadForexPairs() async {
    try {
      List<ForexPair> pairs = await _forexRepository.getForexPairs();
      setState(() {
        _forexPairs = pairs;
      });
    } catch (e) {
      // Handle error
    }
  }

  void _updatePrices() {
    // TODO: Replace this simulation with real-time price updates from Finnhub API
    setState(() {
      _forexPairs = _forexPairs.map((pair) {
        // Simulate price change
        double change = (0.0001 * (1 - 2 * (DateTime.now().second % 2))).toDouble();
        double newPrice = pair.currentPrice + change;
        return ForexPair(
          symbol: pair.symbol,
          currentPrice: newPrice,
          change: change,
          percentChange: (change / pair.currentPrice) * 100,
        );
      }).toList();
    });
  }

  void _onItemTapped(int index) {
    if (index == 0) {
      setState(() {
        _selectedIndex = index;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('This menu item is disabled')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FXTM Forex Tracker'),
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
      return Center(child: CircularProgressIndicator());
    } else {
      return ListView.separated(
        itemCount: _forexPairs.length,
        separatorBuilder: (context, index) => Divider(height: 1),
        itemBuilder: (context, index) {
          final pair = _forexPairs[index];

          // Determine if price went up or down
          bool isPriceUp = pair.change >= 0;

          // Choose the appropriate arrow icon
          IconData arrowIcon = isPriceUp ? Icons.arrow_upward : Icons.arrow_downward;
          Color arrowColor = isPriceUp ? Colors.green : Colors.red;

          return ListTile(
            leading: Icon(arrowIcon, color: arrowColor),
            title: Text(
              pair.symbol,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
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
