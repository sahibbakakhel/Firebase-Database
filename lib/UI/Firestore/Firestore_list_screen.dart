
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_firt_app/UI/Auth/Login_Screen.dart';
import 'package:firebase_firt_app/UI/Firestore/add_firestore_data.dart';
import 'package:firebase_firt_app/Utils/utils.dart';
import 'package:flutter/material.dart';

class FirestoreListScreen extends StatefulWidget {
  const FirestoreListScreen({super.key});

  @override
  State<FirestoreListScreen> createState() => _FirestoreListScreenState();
}

class _FirestoreListScreenState extends State<FirestoreListScreen> {

  final auth=FirebaseAuth.instance;
  final editControlar= TextEditingController();
  //final fireStore=FirebaseFirestore.instance.collection('users').snapshots;
  final fireStore=FirebaseFirestore.instance;
  final ref=FirebaseFirestore.instance.collection('users');
  //final ref1=FirebaseFirestore.instance.collection('users');

  void initState(){
    super.initState();
  }

  Future<void> showMyDialog(String title, String id) async{
    editControlar.text= title;
    showDialog(
      context: context, 
      builder: (BuildContext context){
        return AlertDialog(
          title: Text("Apdate"),
          content: Container(
            child: TextField(
              controller: editControlar,
              decoration: InputDecoration(
                //hintText: 'Edit',
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              }, 
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async{
               await ref.doc().update({
                  "title": editControlar.text.trim().toString()
                }).then((value){
                  Utils().toastMessage('Post updated');
                }).onError((error, stackTrace){
                  Utils().toastMessage(error.toString());
                });
              }, 
              child: Text('Update'),
            )
          ],
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Firestore Screen'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: (){
              auth.signOut().then((value){
                Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
              }).onError((error, stackTrace){
                Utils().toastMessage(error.toString());
              });
            }, icon: Icon(Icons.logout_outlined)),
            SizedBox(width: 10,),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 10,),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection("users").snapshots(),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState==ConnectionState.waiting)
                return CircularProgressIndicator();

                if (snapshot.hasError)
                  return Text('Some error');

              return Expanded(
              child: ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
              final  res = snapshot.data!.docs[index];
                return ListTile(
                  onTap: () {
                    ref.doc(res['id'].toString()).delete();
                  },
                  title: Text(res['title'].toString()),
                  subtitle: Text(res['id'].toString()),
                  trailing: PopupMenuButton(
                    icon: Icon(Icons.more_vert),
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            value: 1,
                            child: ListTile(
                              leading: Icon(Icons.edit),
                              title: Text('Edit'),
                              onTap: () {
                                Navigator.pop(context);
                                showMyDialog(
                                  res['title'].toString(),
                                 res['id'].toString(),);
                              },
                            )
                          ),
                          PopupMenuItem(
                            value: 1,
                            child: ListTile(
                              leading: Icon(Icons.delete),
                              title: Text('Delete'),
                              onTap: ()async {
                              await  ref.doc(res.id).delete(); 
                              },
                            )
                          )
                        ]
                ),
                );
              },
            )
           );
          }
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
      onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => AddFirestoreData()));
      },
      child: Icon(Icons.add),
      ),
    );
  }
}