import '../models/forex_pair.dart';
import '../services/finnhub_service.dart';

class ForexRepository {
  final FinnhubService _service;

  ForexRepository(this._service);

  Future<List<ForexPair>> getForexPairs() {
    return _service.fetchForexPairs();
  }

  Future<List<Map<String, dynamic>>> getHistoricalData(String symbol) {
    return _service.fetchHistoricalData(symbol);
  }
}
