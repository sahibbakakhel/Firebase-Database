import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_firt_app/Utils/utils.dart';
import 'package:firebase_firt_app/Widgets/round_bottom.dart';
import 'package:firebase_storage/firebase_storage.dart';
//import 'package:firebase_storage/firebase_storage.dart as firebase_storage';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UploadImage extends StatefulWidget {
  const UploadImage({super.key});

  @override
  State<UploadImage> createState() => _UploadImageState();
}

class _UploadImageState extends State<UploadImage> {

  // ignore: unused_field
  File? _image;
  final picker=ImagePicker();

  bool loading = false;
  FirebaseStorage storage = FirebaseStorage.instance;
  DatabaseReference databaseRef = FirebaseDatabase.instance.ref('Post');
  //firebase_storage.FirebaseStorage storage= firestore_storage.FirebaseStorage.instance;

  Future getImageGalary()async{
    final pickedFile= await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    setState(() {
      if (pickedFile != null){
      _image=File(pickedFile.path);
    }
    else
    {
      print('no image picked');
    }
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: InkWell(
                onTap: () {
                  getImageGalary();
                },
                child: Container(
                  height: 200,
                  width: 200,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black,
                    )
                  ),
                  child: _image != null? Image.file(_image!.absolute): Icon(Icons.image),
                ),
              ),
            ),
            SizedBox(height: 30,),
            RoundBotton(
              title: 'Upload', 
              loading: loading,
              onTap: () async {
                setState(() {
                  loading = true;
                });
                Reference ref = FirebaseStorage.instance.ref('/foldername/'+DateTime.now().millisecondsSinceEpoch.toString());
                UploadTask uploadTask = ref.putFile(_image!.absolute);

                await Future.value(uploadTask);
                var newUrl = await ref.getDownloadURL();

                databaseRef.child('1').set({
                  'id' : '1212',
                  'title' : newUrl.toString()
                }).then((value){
                  Utils().toastMessage("Uploaded");
                  setState(() {
                    loading = false;
                  });
                }).onError((error, stackTrace){
                  Utils().toastMessage(error.toString());
                    setState(() {
                    loading = false;
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