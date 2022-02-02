import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:orlove_app/models/cart_model.dart';
import 'package:orlove_app/models/favorites_model.dart';
import 'package:orlove_app/screens/splash/splash_screen.dart';
import 'package:orlove_app/storage/storage.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ],
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SecureStorage.isLogged = false;

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<FavoritesModel>(
          create: (_) => FavoritesModel(),
        ),
        ChangeNotifierProvider<CartModel>(
          create: (_) => CartModel(),
        ),
      ],
      child: MaterialApp(
        title: 'ORLOVE',
        debugShowCheckedModeBanner: false,
        home: SplashScreen(),
      ),
    );
  }
}
