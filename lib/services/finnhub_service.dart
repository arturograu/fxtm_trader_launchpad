import 'dart:async';
import 'dart:convert';

import 'package:rxdart/rxdart.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

abstract class FinnhubService {
  Stream<List<ForexTrade>> get forexTrades;
  void subscribeToTrade(String symbol);
  void unsubscribeFromTrade(String symbol);
  void close();
  Future<List<Map<String, dynamic>>> fetchHistoricalData(String symbol);
}

class FinnhubServiceImpl implements FinnhubService {
  FinnhubServiceImpl({
    required String apiKey,
  }) : _apiKey = apiKey {
    _connect();
  }

  final _forexTradesController = BehaviorSubject<List<ForexTrade>>();
  final Set<String> _subscribedPairs = {};
  final String _apiKey;
  late WebSocketChannel _channel;

  @override
  Stream<List<ForexTrade>> get forexTrades => _forexTradesController.stream;

  void _connect() {
    final url = 'wss://ws.finnhub.io?token=$_apiKey';
    _channel = WebSocketChannel.connect(Uri.parse(url));

    _channel.stream.listen(
      (message) => _handleMessage(message),
      onError: (error) => throw Exception('WebSocket Error: $error'),
    );
  }

  void _handleMessage(String message) {
    final data = jsonDecode(message);
    List<ForexTrade> forexTrades = [];

    if (data is Map<String, dynamic> && data['type'] == 'trade') {
      for (var trade in data['data']) {
        forexTrades.add(ForexTrade.fromJson(trade));
      }
    }

    _forexTradesController.add(forexTrades);
  }

  @override
  void subscribeToTrade(String symbol) {
    if (!_subscribedPairs.contains(symbol)) {
      final subscriptionMessage =
          jsonEncode({'type': 'subscribe', 'symbol': symbol});
      _channel.sink.add(subscriptionMessage);
      _subscribedPairs.add(symbol);
    }
  }

  @override
  void unsubscribeFromTrade(String symbol) {
    if (_subscribedPairs.contains(symbol)) {
      final unsubscriptionMessage =
          jsonEncode({'type': 'unsubscribe', 'symbol': symbol});
      _channel.sink.add(unsubscriptionMessage);
      _subscribedPairs.remove(symbol);
    }
  }

  @override
  void close() {
    _forexTradesController.close();
    _channel.sink.close();
  }

  @override
  Future<List<Map<String, dynamic>>> fetchHistoricalData(String symbol) async {
    // TODO: Implement API call to fetch historical data
    return [];
  }
}

class ForexTrade {
  const ForexTrade({
    required this.symbol,
    required this.price,
  });

  final String symbol;
  final double price;

  factory ForexTrade.fromJson(Map<String, dynamic> json) {
    return ForexTrade(
      price: json['p'],
      symbol: json['s'],
    );
  }
}
