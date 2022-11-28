import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:login_mechanism/screens/home_page.dart';
import 'package:login_mechanism/screens/login_page.dart';
import 'package:login_mechanism/screens/signup_page.dart';
import 'package:login_mechanism/screens/splash_screen.dart';

import 'global.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: buildMaterialColor(Global.color),
      ),
      initialRoute: "splash_screen",
      routes: {
        "splash_screen": (context) => const SplashScreen(),
        "/": (context) => const HomePage(),
        "login_page": (context) => const LoginPage(),
        "signup_page": (context) => const SignUpPage(),
      },
    ),
  );
}

MaterialColor buildMaterialColor(Color color) {
  List strengths = <double>[.05];
  Map<int, Color> swatch = {};
  final int r = color.red, g = color.green, b = color.blue;

  for (int i = 1; i < 10; i++) {
    strengths.add(0.1 * i);
  }
  for (var strength in strengths) {
    final double ds = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.fromRGBO(
      r + ((ds < 0 ? r : (255 - r)) * ds).round(),
      g + ((ds < 0 ? g : (255 - g)) * ds).round(),
      b + ((ds < 0 ? b : (255 - b)) * ds).round(),
      1,
    );
  }
  return MaterialColor(color.value, swatch);
}
