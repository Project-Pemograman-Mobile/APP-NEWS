import 'package:flutter/material.dart';
import 'news_list.dart';

class LoginPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome to News App'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Gambar di tengah sebelum kotak email
            Container(
              alignment: Alignment.center,
              child: Image.asset(
                'assets/logo.png',
                fit: BoxFit.contain, // Ganti dengan path gambar Anda
                width: double.infinity, // Sesuaikan dengan ukuran gambar Anda
                height: 200, // Sesuaikan dengan ukuran gambar Anda
              ),
            ),
            SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(labelText: 'Email'),
            ),
            SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                // Navigate to NewsList
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => NewsList()),
                );
              },
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
