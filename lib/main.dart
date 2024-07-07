import 'package:flutter/material.dart';
import 'package:news_app/login_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:news_app/splash_screen.dart';

import 'firebase_options.dart';


void main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
); 
  runApp(MyApp());}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'News App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.light, 
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      themeMode:
          ThemeMode.system, 
      home: SplashScreen(
        child: LoginPage(),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
