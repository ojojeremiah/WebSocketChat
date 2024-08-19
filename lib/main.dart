import 'package:flutter/material.dart';
import 'package:interview_test/screen/LoginScreen.dart';
import 'package:interview_test/screen/WebSocketChat.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(),
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginScreen(),
        '/chat': (context) => const WebSocketChat(),
      },
    );
  }
}
