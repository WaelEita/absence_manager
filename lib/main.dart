import 'package:flutter/material.dart';
import 'package:absence_manager/view/home_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      color: Colors.teal,
      debugShowCheckedModeBanner: false,
      title: 'AbsenceManager',
      home: const HomeScreen(),
    );
  }
}
