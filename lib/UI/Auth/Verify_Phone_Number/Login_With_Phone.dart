import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_firt_app/UI/Auth/Verify_Phone_Number/Verify_with_code.dart';
import 'package:firebase_firt_app/Utils/utils.dart';
import 'package:firebase_firt_app/Widgets/round_bottom.dart';
import 'package:flutter/material.dart';

class LoginWithPhone extends StatefulWidget {
  const LoginWithPhone({super.key});

  @override
  State<LoginWithPhone> createState() => _LoginWithPhoneState();
}

// keytool -list -v -keystore "C:\Users\bilal\.android\debug.keystore" -alias androiddebugkey -storepass android -keypass android


class _LoginWithPhoneState extends State<LoginWithPhone> {

  bool loading=false;
  final phoneNumberControlar=TextEditingController();
  final auth=FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("Login Phone")),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SizedBox(height: 80,),
            TextFormField(
              controller: phoneNumberControlar,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: '+92 000 000 000',
              ),
            ),
            SizedBox(height: 80,),
            RoundBotton(
              title: 'Login', 
              loading: loading,
              onTap: (){
                setState(() {
                  loading=true;
                });
                auth.verifyPhoneNumber(
                  phoneNumber: phoneNumberControlar.text,
                  verificationCompleted: (_){
                    setState(() {
                      loading=false;
                    });
                  }, 
                  timeout:Duration(seconds: 60),
                  verificationFailed: (e){
                    setState(() {
                      loading=false;
                    });
                    Utils().toastMessage(e.toString());
                  }, 
                  codeSent: (String verificationId, int? token){
                    print(verificationId.toString());
                    Navigator.push(context, MaterialPageRoute(builder: (context) => VerifyWithCode(verificationId: verificationId,)));
                    setState(() {
                      loading=false;
                    });
                  },
                  codeAutoRetrievalTimeout: (e){
                    Utils().toastMessage(e.toString());
                    setState(() {
                      loading=false;
                    });
                  });
              })
          ],
        ),
      ),
    );
  }
}