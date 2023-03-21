import 'dart:async';
import 'package:flutter/material.dart';
import 'Create_account.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(
        Duration(seconds: 1),
        (() => Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => RegistrationScreen()))));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
            Color(0xff0F68ED).withOpacity(0.75),
            Color(0xff1DB0A8)
          ])),
      child: Center(child: Image(image: AssetImage('images/veta.png'))),
    );
  }
}
