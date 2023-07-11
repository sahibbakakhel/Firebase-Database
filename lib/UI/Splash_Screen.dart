import 'package:firebase_firt_app/Firebase_Services/splash_services.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  SplashServices splashScreen= SplashServices();

  void initState(){
    super.initState();
    splashScreen.isLogin(context);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Firebase tutorial",style: TextStyle(fontSize: 30),),
      )
    );
  }
}