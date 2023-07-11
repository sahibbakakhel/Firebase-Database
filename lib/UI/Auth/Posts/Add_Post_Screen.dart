import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_firt_app/Utils/utils.dart';
import 'package:firebase_firt_app/Widgets/round_bottom.dart';
import 'package:flutter/material.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {

  final postControlar=TextEditingController();
  bool loading=false;
  final databaseRef=FirebaseDatabase.instance.ref('Post');


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Add Post Screen'),),
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
                String id= DateTime.now().microsecondsSinceEpoch.toString();
                databaseRef.child(id).set({
                  "tital": postControlar.text.toString(),
                  'id': id,
                }).then((value){
                  Utils().toastMessage('Post added');
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