import 'package:flutter/material.dart';
import 'screens/alert_screen.dart';

void main() {
  runApp(const StockAlertApp());
}

class StockAlertApp extends StatelessWidget {
  const StockAlertApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NSE Stock Alert',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const AlertScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
