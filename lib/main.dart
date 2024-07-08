import 'package:flutter/material.dart';
import 'package:absence_manager/view/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      color: Colors.teal,
      debugShowCheckedModeBanner: false,
      title: 'AbsenceManager',
      home: HomeScreen(),
    );
  }
}
