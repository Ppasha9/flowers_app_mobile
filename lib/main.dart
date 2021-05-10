import 'package:flutter/material.dart';
import 'package:orlove_app/screens/splash/splash_screen.dart';
import 'package:orlove_app/storage/storage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SecureStorage.isLogged = false;

    return MaterialApp(
      title: 'ORLOVE Demo',
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
