import 'dart:async';

import 'package:gemini_bot/pages/HomePage.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void initState(){
    super.initState();
    startTimer();
  }

  startTimer(){
    var duration = const Duration(seconds: 4);
    return Timer(duration,route);
  }

  route (){
    Navigator.push(context, MaterialPageRoute(builder: (context) => const HomePage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children:[
          Center(
            child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                height: MediaQuery.of(context).size.height / 2,
                child: Lottie.asset('assets/Animation.json')),
          ),
          const Text('Loading...',style: TextStyle(
            fontFamily: "Sixtyfour"
          ),)
        ]
      ),
    );
  }
}
