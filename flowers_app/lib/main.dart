import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'screens/splash.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<void> _signout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool("isLogged", false);
  }

  @override
  void initState() {
    super.initState();
    _signout().then((value) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lavanda App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        canvasColor: Colors.transparent,
      ),
      home: SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
