// ignore_for_file: unused_local_variable

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_firt_app/UI/Auth/Login_Screen.dart';
import 'package:firebase_firt_app/Utils/utils.dart';
import 'package:firebase_firt_app/Widgets/round_bottom.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  
  bool looding=false;
  final _formKey=GlobalKey<FormState>();
  final emailControlar=TextEditingController();
  final passwordControlar=TextEditingController();

  FirebaseAuth _auth= FirebaseAuth.instance;

  void dispose(){
    super.dispose();
    emailControlar.dispose();
    passwordControlar.dispose();
  }

  void login(){
    setState(() {
    looding=true;
    });
      _auth.createUserWithEmailAndPassword(
        email: emailControlar.text.toString(), 
        password: passwordControlar.text.toString(),).then((value){
          setState(() {
            looding=false;
          });
        }).onError((error, stackTrace){
          Utils().toastMessage(error.toString());
            setState(() {
            looding=false;
           });
   });                        
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          title: Center(child: Text('Sign Up')),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: emailControlar,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        hintText: 'Email',
                        //helperText: 'enter email e.g jon@gmail.com',
                        prefixIcon: Icon(Icons.email),
                      ),
                      validator: (value){
                        if (value!.isEmpty){
                          return 'Enter Email';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20,),
                    TextFormField(
                      controller: passwordControlar,
                      keyboardType: TextInputType.text,
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: 'Password',
                        //helperText: 'enter email e.g jon@gmail.com',
                        prefixIcon: Icon(Icons.lock_outline),
                      ),
                      validator: (value){
                        if (value!.isEmpty){
                          return 'Enter Password';
                        }
                        return null;
                      },
                    ),
                  ],
                )
              ),
              RoundBotton(
                title: "Sign Up",
                loading: looding,
                onTap: () {
                  if(_formKey.currentState!.validate());{
                    login();
                  }
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text("We have an acount?"),
                  TextButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> LoginScreen()));
                    },
                    child: Text('Log In')
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}