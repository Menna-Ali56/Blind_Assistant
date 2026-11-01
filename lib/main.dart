import 'package:flutter/material.dart';

void main() {
  runApp(const BlindApp());
}

class BlindApp extends StatelessWidget {
  const BlindApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Blind App',
      home: Scaffold(
        body: Center(
          child: Text('Welcome to the Blind App'),
        ),
      ),
    );
  }
}
