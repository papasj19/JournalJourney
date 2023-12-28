import 'package:camera/camera.dart';
import 'package:dailydiary/addEntry.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
class HomePage extends StatelessWidget{
  final CameraDescription firstCamera;
  const HomePage({super.key, required this.firstCamera});


  
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

      body: ListView(



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