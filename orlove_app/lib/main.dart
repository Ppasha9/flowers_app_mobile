import 'package:flutter/material.dart';
import 'package:orlove_app/screens/splash/splash_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ORLOVE Demo',
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
