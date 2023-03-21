

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:veta/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();



  runApp(DevicePreview(
    enabled : false,
    builder :  (context) =>
    
    Veta()));
}

final navigatorKey = GlobalKey<NavigatorState>();

class Veta extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      home: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('An error has occur'),
              );
            } else if (snapshot.hasData) {
              return SplashScreen();
            } else {
              return SplashScreen();
            }
          }), 
    );
  }
}
