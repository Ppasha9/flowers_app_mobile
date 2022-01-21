import 'dart:async';

import 'package:flutter/material.dart';
import 'package:orlove_app/constants.dart';
import 'package:orlove_app/models/favorites_model.dart';
import 'package:orlove_app/screens/signin/signin_screen.dart';
import 'package:provider/provider.dart';

import '../home/home_screen.dart';

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
      backgroundColor: ProjectConstants.BACKGROUND_SPLASH_SCREEN_COLOR,
      body: Center(
        child: Container(
          width: 288, //mediaQuery.size.width * 0.70,
          height: 42, //mediaQuery.size.height * 0.07,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/orlove_text.png"),
              fit: BoxFit.fill,
            ),
          ),
        ),
      ),
    );
  }
}
