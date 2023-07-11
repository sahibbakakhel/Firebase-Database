
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_firt_app/UI/Auth/Login_Screen.dart';
import 'package:firebase_firt_app/UI/Auth/Posts/Add_Post_Screen.dart';
import 'package:firebase_firt_app/Utils/utils.dart';
import 'package:flutter/material.dart';

class PostsScreen extends StatefulWidget {
  const PostsScreen({super.key});

  @override
  State<PostsScreen> createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {

  final ref=FirebaseDatabase.instance.ref('Post');
  final auth=FirebaseAuth.instance;
  final searchFilter= TextEditingController();
  final editControlar= TextEditingController();

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
              onPressed: () {
                Navigator.pop(context);
                ref.child(id).update({
                  "title": editControlar.text.toLowerCase(),
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
        title: Text('Posts Screen'),
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TextFormField(
              controller: searchFilter,
              decoration: InputDecoration(
                hintText: 'Search',
                border: OutlineInputBorder(),
              ),
              onChanged: (String value) {
                setState(() {
                });
              },
            ),
          ),
          // StreamBuilder(
          //   stream: ref.onValue,
          //   builder: ((context, AsyncSnapshot<DatabaseEvent> snapshot) {
          //     if (!snapshot.hasData){
          //       return Center(child: CircularProgressIndicator());
          //     }else{
          //       // ignore: unused_local_variable
          //       Map<dynamic, dynamic> map= snapshot.data!.snapshot.value as dynamic;
          //       List<dynamic> list=[];
          //       list.clear();
          //       list=map.values.toList();
          //       return Expanded(
          //         child: ListView.builder(
          //         itemCount: snapshot.data!.snapshot.children.length,
          //         itemBuilder: (context,index){
          //           return ListTile(
          //             title: Text(list[index]["tital"]),
          //             subtitle: Text(list[index]["id"]),
          //           );
          //         }
          //         ),
          //       );
          //     }
          //   })
          //   ),
          Expanded(
            child: FirebaseAnimatedList(
              query: ref,
              defaultChild: Text('loading'), 
              itemBuilder: (context, snapshot, animation, index){
                final title= snapshot.child('tital').value.toString();
                if (searchFilter.text.isEmpty){
                  return ListTile(
                  title: Text(snapshot.child('tital').value.toString()),
                  subtitle: Text(snapshot.child('id').value.toString()),
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
                            showMyDialog(title, snapshot.child('id').value.toString());
                          },
                        ),
                      ),
                      PopupMenuItem(
                        value: 1,
                        child: ListTile(
                          leading: Icon(Icons.delete),
                          title: Text('Delete'),
                          onTap: () {
                            Navigator.pop(context);
                            ref.child(snapshot.child('id').value.toString()).remove();
                          },
                        ),
                      ),
                    ]
                  ),
                );
                }
                else if(title.toLowerCase().contains(searchFilter.text.toLowerCase().toLowerCase())){
                  return ListTile(
                  title: Text(snapshot.child('tital').value.toString()),
                  subtitle: Text(snapshot.child('id').value.toString()),
                );
              }
              else
                {
                  return Container();
                }
              }
            )
          ),
        
        ],
      ),
      floatingActionButton: FloatingActionButton(
      onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => AddPostScreen()));
      },
      child: Icon(Icons.add),
      ),
    );
  }
}