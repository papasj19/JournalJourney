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


  Future<List<JournalEntry>> getEntries() async {
    User? currentUser = await FirebaseAuth.instance.currentUser;
    String? userId = currentUser?.uid;
    var db = FirebaseFirestore.instance;
    QuerySnapshot<Map<String, dynamic>>  querySnapshot =
    await db.collection("userData").doc(userId).collection("entry").get();

    // Convert QueryDocumentSnapshot to Map
    List<Map<String, dynamic>> entriesData =
    querySnapshot.docs.map((doc) => doc.data()).toList();
    List<JournalEntry> entries =
    entriesData.map((data) => JournalEntry.fromMap(data)).toList();
    return entries;
  }


  void deleteEntry(JournalEntry entry) async {
    User? currentUser = await FirebaseAuth.instance.currentUser;
    String? userId = currentUser?.uid;
    var db = FirebaseFirestore.instance;
    QuerySnapshot querySnapshot = await db
        .collection("userData").doc(userId).collection("entry").
        where('entry', isEqualTo: entry.entry).where('date', isEqualTo: entry.date).where('score', isEqualTo: entry.score)
        .get();

    //get the id of the doc of our recipe
    var firstDocument = querySnapshot.docs.first;

    //delete the childs
    final docRef = db.collection("userData").doc(userId).collection("entry").doc(firstDocument.id);
    final updates = <String, dynamic>{
      "score": FieldValue.delete(),
      "date": FieldValue.delete(),
      "entry": FieldValue.delete(),
    };
    await docRef.update(updates);

    //delete the doc
    await db.collection("userData").doc(userId).collection("entry").doc(firstDocument.id).delete();
    //notifyListeners();  -----> what does this do??
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
              future: getEntries(),
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
                            leading: CircleAvatar(child: Text(entries[index].score)),
                          title: Text(entries[index].date),
                            trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => deleteEntry(entries[index]),
                      ),
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