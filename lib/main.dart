import 'package:flutter/material.dart';
import 'pages/main_page.dart';

void main() {
  runApp(FXTMApp());
}

class FXTMApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FXTM Forex Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MainPage(),
    );
  }
}
