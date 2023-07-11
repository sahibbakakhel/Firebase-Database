import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_firt_app/Utils/utils.dart';
import 'package:firebase_firt_app/Widgets/round_bottom.dart';
import 'package:flutter/material.dart';

class AddFirestoreData extends StatefulWidget {
  const AddFirestoreData({super.key});

  @override
  State<AddFirestoreData> createState() => _AddFirestoreDataState();
}

class _AddFirestoreDataState extends State<AddFirestoreData> {

  final postControlar=TextEditingController();
  bool loading=false;
  final fireStore=FirebaseFirestore.instance.collection('users');


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Add Firestore Data'),),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SizedBox(height: 30,),
            TextFormField(
              controller: postControlar,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: 'What is in your mind',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 30,),
            RoundBotton(
              title: "Add", 
              loading: loading,
              onTap: () {
                setState(() {
                  loading=true;
                });
                String id= DateTime.now().millisecondsSinceEpoch.toString();
                fireStore.doc().set({
                  'title': postControlar.text.toString(),
                  'id': id,
                }).then((value){
                  Utils().toastMessage('Post Added');
                  setState(() {
                  loading=false;
                });
                }).onError((error, stackTrace){
                  Utils().toastMessage(error.toString());
                  setState(() {
                  loading=false;
                });
                });
              },
            )
          ],
        ),
      ),
    );
  }
}