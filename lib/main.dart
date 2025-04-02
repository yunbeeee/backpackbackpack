import 'package:backpack_front/Home/home_main.dart';
import 'package:flutter/material.dart';
import 'package:backpack_front/SignUp/signup_main.dart'; // SignUp
import 'package:backpack_front/SignUp/signup_agree.dart';
import 'package:backpack_front/Home/home_main.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeMain(), // First page
      debugShowCheckedModeBanner: false,
    );
  }
}

