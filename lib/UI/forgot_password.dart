import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_firt_app/Utils/utils.dart';
import 'package:firebase_firt_app/Widgets/round_bottom.dart';
import 'package:flutter/material.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {

  final emailControlar= TextEditingController();
  final auth= FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('forgot password'),),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextFormField(
              controller: emailControlar,
              decoration: InputDecoration(
                hintText: 'Email',
              ),
            ),
            SizedBox(height: 50,),
            RoundBotton(
              title: 'Forgot', 
              onTap: (){
                auth.sendPasswordResetEmail(email: emailControlar.text.toString()).then((value){
                  Utils().toastMessage('We have reset password and check the eamil');
                }).onError((error, stackTrace){
                  Utils().toastMessage(error.toString());
                });
              }
            )
          ],
        ),
      ),
    );
  }
}