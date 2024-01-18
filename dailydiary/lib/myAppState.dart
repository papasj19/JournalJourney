import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import 'addEntry.dart';

class MyAppState extends ChangeNotifier {
  var selectedIndex = 0;

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
    where('entry', isEqualTo: entry.entry).where('date', isEqualTo: entry.date).where('score', isEqualTo: entry.score).where('picture', isEqualTo: entry.picture).where('title', isEqualTo: entry.title).get();

    //get the id of the doc of our recipe
    var firstDocument = querySnapshot.docs.first;

    //delete the childs
    final docRef = db.collection("userData").doc(userId).collection("entry").doc(firstDocument.id);
    final updates = <String, dynamic>{
      "score": FieldValue.delete(),
      "date": FieldValue.delete(),
      "entry": FieldValue.delete(),
      "picture": FieldValue.delete(),
      "title": FieldValue.delete(),
    };
    await docRef.update(updates);

    //delete the doc
    await db.collection("userData").doc(userId).collection("entry").doc(firstDocument.id).delete();
    notifyListeners();
  }



}