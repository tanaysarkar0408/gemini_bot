import 'package:gemini_bot/pages/SplashScreen.dart';
import 'package:flutter/material.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Chat Bot',
      theme: ThemeData(
        fontFamily: "Orbitron",
          brightness: Brightness.dark,
          scaffoldBackgroundColor: Colors.grey[700],
          primaryColor: const Color(0xffB47AC0)),
      home: const SplashScreen(),
    );
  }
}
