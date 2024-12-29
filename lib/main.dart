import 'package:flutter/material.dart';
import 'package:invantory/pages/homescreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Inventory Management',
      home: HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}