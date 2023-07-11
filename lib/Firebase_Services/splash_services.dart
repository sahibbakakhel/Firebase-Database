
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_firt_app/UI/Auth/Login_Screen.dart';
import 'package:firebase_firt_app/UI/Auth/Posts/Posts_Screen.dart';
import 'package:flutter/material.dart';

class SplashServices{

  void isLogin(BuildContext context){

    final auth=FirebaseAuth.instance;
    final user=auth.currentUser;

    if (user!=null){
      Timer(Duration(seconds: 3), () { 
      Navigator.push(context, MaterialPageRoute(builder: (context) => PostsScreen()));
    });
    }
    else
    {
      Timer(Duration(seconds: 3), () { 
      Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
    });
    }
  }
}