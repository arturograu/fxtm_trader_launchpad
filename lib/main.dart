import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'pages/main_page.dart';

void main() async {
  await dotenv.load();
  runApp(const FXTMApp());
}

class FXTMApp extends StatelessWidget {
  const FXTMApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FXTM Forex Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MainPage(),
    );
  }
}
