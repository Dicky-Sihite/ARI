import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Tentang Aplikasi')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/logo_ari.png',
                width: 200,
              ),
              SizedBox(height: 5),
              SizedBox(height: 5),
              Text('Versi 1.0.0'),
              SizedBox(height: 5),
            ],
          ),
        ),
      ),
    );
  }
}