import 'package:flutter/material.dart';
import 'login_page.dart';// Import the login page
import 'frontpage.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginPage(), // Use the LoginPage as the initial page
    );
  }
}





