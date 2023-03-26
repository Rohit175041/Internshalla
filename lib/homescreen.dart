import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intern/login/login.dart';
import 'package:intern/postmessage/postmessage.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    //secure local storage
    const storage = FlutterSecureStorage();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Homescreen"),
        actions: [
          //logout
          IconButton(
              onPressed: () async {
                await storage.deleteAll();
                await FirebaseAuth.instance.signOut();
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginPhone(),
                    ),
                    (route) => false);
              },
              icon: const Icon(Icons.logout))
        ],
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream:
            FirebaseFirestore.instance.collection('postmessage').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return ListView(
            children: snapshot.data!.docs.map((document) {
              return Padding(
                padding: const EdgeInsets.only(left: 5.0, right: 5, top: 5),
                child: Card(
                  color: Colors.white54,
                  elevation: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Name: ${document['name']}",
                              style: const TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.black,
                              ),
                              onPressed: () async {
                                alert(document.id);
                              },
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Gender: ${document['gender']}",
                              style: const TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "Country: ${document['country']}",
                              style: const TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w600),
                            ),
                            Text(
                              "Age: ${document['age']}",
                              style: const TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          "𝐇𝐨𝐛𝐛𝐢𝐞𝐬: ${document['hobbies']}",
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.normal),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),

      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => const Postmessage(),
              ),
              (route) => true);
        },
        elevation: 2.0,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  //deleting post
  deleteData(id) async {
    await FirebaseFirestore.instance
        .collection("postmessage")
        .doc(id)
        .delete()
        .whenComplete(() {
      print("post deleted");
      showSnackBar(Colors.green, "deleted");
    }).catchError((error) {
      print("Failed to delete note with ID $id: $error");
    });
  }

  void alert(dynamic id) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Delete"),
        content: const Text("Want to delete?"),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.all(14),
              child: const Text("No"),
            ),
          ),
          TextButton(
            onPressed: (){
              deleteData(id);
               Future.delayed( const Duration(milliseconds: 200));
              Navigator.of(ctx).pop();
            },
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.all(14),
              child: const Text("Yes"),
            ),
          ),
        ],
      ),
    );
  }

  //message bar
  void showSnackBar(dynamic color, String text) {
    var snackBar = SnackBar(
        backgroundColor: color,
        duration: const Duration(seconds: 1),
        content: Text(text));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
