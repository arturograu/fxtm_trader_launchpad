import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

abstract class ForexRateService {
  Future<List<ForexRatePair>> fetchForexPairs();
}

class ForexRateServiceImpl implements ForexRateService {
  ForexRateServiceImpl({
    required String apiKey,
  }) : _apiKey = apiKey;

  final String _apiKey;
  final String _baseUrl = 'https://api.forexrateapi.com/v1/latest';

  @override
  Future<List<ForexRatePair>> fetchForexPairs() async {
    final uri = Uri.parse('$_baseUrl?api_key=$_apiKey');
    final response = await http.get(uri);

    if (response.statusCode == HttpStatus.ok) {
      final data = json.decode(response.body);
      final rates = data['rates'] as Map<String, dynamic>;

      return rates.entries.map((entry) {
        return ForexRatePair(
          symbol: entry.key,
          currentPrice: (entry.value as num).toDouble(),
        );
      }).toList();
    } else {
      throw Exception('Failed to fetch forex rates');
    }
  }
}

class ForexRatePair {
  const ForexRatePair({
    required this.symbol,
    required this.currentPrice,
  });

  final String symbol;
  final double currentPrice;
}
