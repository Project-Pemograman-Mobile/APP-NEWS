import 'package:flutter/material.dart';
import 'package:news_app/login_page.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'News App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.light, // Mengatur tema awal ke light
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      themeMode:
          ThemeMode.system, // Menggunakan tema yang disesuaikan dengan sistem
      home: LoginPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
