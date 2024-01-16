import 'dart:developer';

import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dailydiary/addEntry.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
class HomePage extends StatelessWidget{
  final CameraDescription firstCamera;
  const HomePage({super.key, required this.firstCamera});

  Future<Stream<QuerySnapshot<Object?>>> getMeTheEntries() async {
    User? currentUser = await FirebaseAuth.instance.currentUser;
    String? userId = currentUser?.uid;
    return FirebaseFirestore.instance.collection("userData").doc(userId).collection("entry").snapshots();
  }

  Future<void> getAllEntries() async {
    User? currentUser = await FirebaseAuth.instance.currentUser;
    String? userId = currentUser?.uid;
    CollectionReference productsRef =
    FirebaseFirestore.instance.collection("userData").doc(userId).collection("entry");
    final snapshot = await productsRef.get();
    List<Map<String, dynamic>> map =
    snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
  }


  Future<List<JournalEntry>> retrieveEntries() async {
    User? currentUser = await FirebaseAuth.instance.currentUser;
    String? userId = currentUser?.uid;

    var db = FirebaseFirestore.instance;
    QuerySnapshot<Map<String, dynamic>> snapshot =
    await db.collection("userData").doc(userId).collection("entry").get();

    var returnVal = snapshot.docs
        .map((docSnapshot) => JournalEntry.fromSnap(docSnapshot))
        .toList();

    print(returnVal);

    print("hello bro");

    return returnVal;
  }


  Future<List<JournalEntry>> getEntries() async {
    User? currentUser = await FirebaseAuth.instance.currentUser;
    String? userId = currentUser?.uid;
    var db = FirebaseFirestore.instance;
    QuerySnapshot<Map<String, dynamic>>  querySnapshot =
    await db.collection("userData").doc(userId).collection("entry").get();

    // Convert QueryDocumentSnapshot to Map
    List<Map<String, dynamic>> entriesData =
    querySnapshot.docs.map((doc) => doc.data()).toList();

    print(entriesData);
    List<JournalEntry> entries =
    entriesData.map((data) => JournalEntry.fromMap(data)).toList();
    print(entries);
    print("wtf");
    print("Wtf");
    return entries;
  }



  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Diary', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 1,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute<ProfileScreen>(
                  builder: (context) => ProfileScreen(
                    appBar: AppBar(
                      title: const Text('User Profile'),
                    ),
                    actions: [
                      SignedOutAction((context) {
                        Navigator.of(context).pop();
                      })
                    ],
                  ),
                ),
              );
            },
          )
        ],
      ),

      body: Center(
          child: FutureBuilder<List<JournalEntry>>(
              future: retrieveEntries(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                    child: Text('No entries yet.'),
                  );
                } else {
                  List<JournalEntry> entries = snapshot.data!;

                  return ListView.builder(
                    itemCount: entries.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: ListTile(
                          title: Text("lol")
                        ),
                      );
                    },
                  );
                }
              }),


      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Access the firstCamera from the CameraProvider
          Navigator.push(context, MaterialPageRoute(builder: (_) => AddEntry(firstCamera: firstCamera,)));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}