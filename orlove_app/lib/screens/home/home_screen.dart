import 'package:flutter/material.dart';
import 'package:orlove_app/constants.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: ProjectConstants.BACKGROUND_SCREEN_COLOR,
      ),
    );
  }
}
