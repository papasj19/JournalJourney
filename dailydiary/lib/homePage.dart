import 'dart:developer';

import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dailydiary/addEntry.dart';
import 'package:dailydiary/myAppState.dart';
import 'package:dailydiary/showEntry.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';




class HomePage extends StatelessWidget{


  final CameraDescription firstCamera;
  const HomePage({super.key, required this.firstCamera});



  @override
  Widget build(BuildContext context) {

    var appState = context.watch<MyAppState>();


    showEntry(JournalEntry entry) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ShowEntry(entryGiven: entry),
        ),
      );
    }


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
              future: appState.getEntries(),
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
                          onTap: () => showEntry(entries[index]),
                          leading: CircleAvatar(child: Text(entries[index].score)),
                          title: Text(entries[index].date),
                          trailing: IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () => appState.deleteEntry(entries[index]),
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