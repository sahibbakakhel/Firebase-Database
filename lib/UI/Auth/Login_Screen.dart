import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_firt_app/UI/Auth/Verify_Phone_Number/Login_With_Phone.dart';
import 'package:firebase_firt_app/UI/Auth/Posts/Posts_Screen.dart';
import 'package:firebase_firt_app/UI/Auth/Sign_Up.dart';
import 'package:firebase_firt_app/UI/forgot_password.dart';
import 'package:firebase_firt_app/Utils/utils.dart';
import 'package:firebase_firt_app/Widgets/round_bottom.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  
   bool  loading =false;
  GlobalKey<FormState> _formKey=GlobalKey<FormState>();
  final emailControlar=TextEditingController();
  final passwordControlar=TextEditingController();

  final _auth = FirebaseAuth.instance;

  void dispose(){
    super.dispose();
    emailControlar.dispose();
    passwordControlar.dispose();
  }

  void login(){
    setState(() {
      loading =true;
    });
    _auth.signInWithEmailAndPassword(
      email: emailControlar.text.toString(), 
      password: passwordControlar.text.toString()).then((value){
        Utils().toastMessage(value.user!.email.toString());
        Navigator.push(context, MaterialPageRoute(builder: (context) => PostsScreen()));
        setState(() {
          loading =false;
        });
    }).onError((error, stackTrace){
      debugPrint(error.toString());
      Utils().toastMessage(error.toString());
      setState(() {
        loading =false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
        SystemNavigator.pop();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Center(child: Text('Login')),
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
                          return null;
                        }
                        return 'Enter Email';
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
              SizedBox(height: 30,),
              RoundBotton(
                title: "Login",
                loading: loading,
                onTap: () {
                  if(_formKey.currentState!.validate());{
                    login();
                  }
                },
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: TextButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> ForgotPassword()));
                    },
                    child: Text('Forgot Password'),
                  ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text("Don't have an acount?"),
                  TextButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> SignUp()));
                    },
                    child: Text('Sign Up')
                  )
                ],
              ),
              InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => LoginWithPhone()));
                },
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: Colors.black
                    ),
                  ),
                  child: Center(
                    child: Text('Login with Phone'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}