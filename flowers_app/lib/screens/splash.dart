import 'dart:async';

import 'package:flowers_app/screens/account/signup.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'home/home.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
      Duration(seconds: 4),
      () => Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (BuildContext context) => HomeScreen(),
          //builder: (BuildContext context) => SignupScreen(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE8E0E7),
      body: Center(
        child: Text(
          'Lavanda',
          style: TextStyle(
            fontSize: 45,
            color: Color(0xFF989797),
            fontFamily: 'Book Antiqua',
          ),
        ),
      ),
    );
  }
}
