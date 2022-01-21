import 'package:flutter/material.dart';
import 'package:orlove_app/models/favorites_model.dart';
import 'package:orlove_app/screens/splash/splash_screen.dart';
import 'package:orlove_app/storage/storage.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SecureStorage.isLogged = false;

    return ChangeNotifierProvider(
      create: (_) => FavoritesModel(),
      child: MaterialApp(
        title: 'ORLOVE',
        debugShowCheckedModeBanner: false,
        home: SplashScreen(),
      ),
    );
  }
}
