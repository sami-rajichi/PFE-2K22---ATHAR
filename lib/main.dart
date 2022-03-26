import 'package:flutter/material.dart';
import 'package:monumento/components/categories/categories_home.dart';
import 'package:monumento/home.dart';
import 'package:monumento/shared/components/liquid_swipe_navigator.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}