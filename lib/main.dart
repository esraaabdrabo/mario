import 'package:flutter/material.dart';
import 'package:mario/views/home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Scaffold(backgroundColor: Colors.blue, body: const Home()),
    );
  }
}
