
import 'package:flutter/material.dart';
import 'homepage.dart';

// @author: M. Rafly Aziz (41821010045)


void main() {
  runApp(const MyApp());
}

// my app stateless
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'CRUD',
      home: HomePage(),
    );
  }
}



