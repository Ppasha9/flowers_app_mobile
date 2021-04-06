import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lavanda_app/constants.dart';
import 'package:lavanda_app/screens/home/home.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
      Duration(seconds: ProjectConstants.SPLASH_SCREEN_DURATION_SECS),
      () => Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (BuildContext ctx) => HomeScreen(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ProjectConstants.SPLASH_SCREEN_COLOR,
      body: Center(
        child: Text(
          'Lavanda',
          style: TextStyle(
            fontFamily: ProjectConstants.APP_FONT_FAMILY,
            fontSize: 46 * MediaQuery.of(context).textScaleFactor,
            color: Color(0xFF989797),
          ),
        ),
      ),
    );
  }
}
