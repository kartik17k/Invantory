import 'package:flutter/material.dart';
import 'package:invantory/pages/homescreen.dart';
import 'package:invantory/pages/loginscreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Inventory Management',
      home: LoginPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}