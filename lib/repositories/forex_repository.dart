import 'package:collection/collection.dart';
import 'package:rxdart/rxdart.dart';

import '../models/forex_pair.dart';
import '../services/finnhub_service.dart';
import '../services/forex_rate_service.dart';

class ForexRepository {
  final FinnhubService _finnhubService;
  final ForexRateService _forexRateService;

  ForexRepository({
    required FinnhubService finnhubService,
    required ForexRateService forexRateService,
  })  : _finnhubService = finnhubService,
        _forexRateService = forexRateService;

  final BehaviorSubject<List<ForexPair>> _forexPairsController =
      BehaviorSubject<List<ForexPair>>();

  Stream<List<ForexPair>> get forexPairs => _forexPairsController.stream;

  Future<List<ForexPair>> getForexPairs() async {
    final forexRatePairs = await _forexRateService.fetchForexPairs();
    final forexPairs = forexRatePairs.map(
      (forexRatePair) {
        return ForexPair(
          symbol: forexRatePair.symbol,
          currentPrice: forexRatePair.currentPrice,
          change: 0,
          percentChange: 0,
        );
      },
    ).toList();
    _forexPairsController.add(forexPairs);
    return forexPairs;
  }

  void subscribeToForexTrades(List<String> symbols) {
    for (var symbol in symbols) {
      _finnhubService.subscribeToTrade(symbol);
    }

    _finnhubService.forexTrades.listen((forexTrades) {
      final updatedPairs = _forexPairsController.value.map((pair) {
        final forexTrade = forexTrades.firstWhereOrNull(
          (trade) => trade.symbol == pair.symbol,
        );
        final oldPrice = pair.currentPrice;
        final newPrice = forexTrade?.price ?? oldPrice;
        final change = newPrice - oldPrice;

        return ForexPair(
          symbol: pair.symbol,
          currentPrice: newPrice,
          change: change,
          percentChange: (change / oldPrice) * 100,
        );
      }).toList();
      _forexPairsController.add(updatedPairs);
    });
  }

  Future<List<Map<String, dynamic>>> getHistoricalData(String symbol) {
    return _finnhubService.fetchHistoricalData(symbol);
  }
}
