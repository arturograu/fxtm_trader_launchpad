import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fxtm/repositories/forex_repository.dart';
import 'package:fxtm/services/finnhub_service.dart';
import 'package:fxtm/services/forex_rate_service.dart';

import 'pages/home_page.dart';

void main() async {
  await dotenv.load();
  final finhubService = FinnhubServiceImpl(apiKey: _getFinnhubApiKey());
  final forexRateService = ForexRateServiceImpl(apiKey: _getForexRateApiKey());
  final forexRepository = ForexRepository(
    finnhubService: finhubService,
    forexRateService: forexRateService,
  );
  runApp(FXTMApp(forexRepository: forexRepository));
}

String _getFinnhubApiKey() {
  final apiKey = dotenv.env['FINNHUB_API_KEY'];
  if (apiKey == null) {
    throw Exception('FINNHUB_API_KEY is not set in .env file');
  }
  return apiKey;
}

String _getForexRateApiKey() {
  final apiKey = dotenv.env['FOREX_RATE_API_KEY'];
  if (apiKey == null) {
    throw Exception('FOREX_RATE_API_KEY is not set in .env file');
  }
  return apiKey;
}

class FXTMApp extends StatelessWidget {
  const FXTMApp({super.key, required ForexRepository forexRepository})
      : _forexRepository = forexRepository;

  final ForexRepository _forexRepository;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: _forexRepository),
      ],
      child: const _AppView(),
    );
  }
}

class _AppView extends StatelessWidget {
  const _AppView();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FXTM',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}
