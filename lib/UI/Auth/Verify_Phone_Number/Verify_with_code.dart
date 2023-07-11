import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_firt_app/UI/Auth/Posts/Posts_Screen.dart';
import 'package:firebase_firt_app/Utils/utils.dart';
import 'package:firebase_firt_app/Widgets/round_bottom.dart';
import 'package:flutter/material.dart';

class VerifyWithCode extends StatefulWidget {
  final String verificationId;
  const VerifyWithCode({super.key, required this.verificationId});

  @override
  State<VerifyWithCode> createState() => _LoginWithPhoneState();
}

class _LoginWithPhoneState extends State<VerifyWithCode> {
  bool loading=false;
  final verifyCodeControlar=TextEditingController();
  final auth=FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("Verify")),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SizedBox(height: 80,),
            TextFormField(
              controller: verifyCodeControlar,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: '6 Digit Code',
              ),
            ),
            SizedBox(height: 80,),
            RoundBotton(
              title: 'Login', 
              loading: loading,
              onTap: () async {
                setState(() {
                  loading =true;
                });
                // ignore: unused_local_variable
                final crendital = PhoneAuthProvider.credential(
                  verificationId: widget.verificationId, 
                  smsCode: verifyCodeControlar.text.toString()
                );
                try{
                  await auth.signInWithCredential(crendital);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => PostsScreen()));
                }
                catch(e)
                {
                  setState(() {
                  loading =false;
                });
                Utils().toastMessage(e.toString());
                }
              })
          ],
        ),
      ),
    );
  }
}