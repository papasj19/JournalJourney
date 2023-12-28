import 'dart:io';
import 'package:camera/camera.dart';
import 'package:dailydiary/homePage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dailydiary/services/auth_services.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class AddEntry extends StatelessWidget{
  final CameraDescription firstCamera;

  const AddEntry({super.key, required this.firstCamera});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    var db = FirebaseFirestore.instance;
    var entryController = TextEditingController();
    var titleController = TextEditingController();
    var moodController = TextEditingController();
    var submitController = TextEditingController();
    DateTime today = DateTime.now();
    String dateStr = "${today.day}-${today.month}-${today.year}";
    var title;

    var scoreEntered = "3";
    String datePrint = "Journal Date: " + dateStr;


    Future<List<JournalEntry>> getEntries() async {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
      await db.collection("Journals").get();

      // Convert QueryDocumentSnapshot to Map
      List<Map<String, dynamic>> entriesData =
      querySnapshot.docs.map((doc) => doc.data()).toList();
      List<JournalEntry> entries =
      entriesData.map((data) => JournalEntry.fromMap(data)).toList();

      return entries;
    }





    Future<void> addEntry(JournalEntry newEntry) async {
      User? currentUser = await FirebaseAuth.instance.currentUser;
      String? userId = currentUser?.uid;
      db.collection("userData").doc(userId).collection("entry").add(newEntry.toMap());
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add a new Entry', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 1,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.camera_alt),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => TakePictureScreen(camera: firstCamera,)));
            },
          )
        ],
      ),
      body: Container(
        alignment: Alignment.topCenter,
        margin: const EdgeInsets.symmetric(horizontal: 30),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child: Text(
                  datePrint,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.openSans(
                      color: Colors.blue, fontSize: 24),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child: TextFormField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Give It A Title?',
                  )
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child:TextFormField(
                    controller: entryController,

                    decoration: const InputDecoration(
                      labelText: 'Your Entry Goes Here',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 8,
                    minLines: 3,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Make sure to add a journal entry!';
                    }
                    return null;
                  }
                  ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),

                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                      child:InkWell(
                            onTap: () {
                              scoreEntered = "10";
                              },
                            child: Ink.image(
                              image: const AssetImage('assets/thumbs_up.png'),
                              // fit: BoxFit.cover,
                              width: 70,
                              height: 70,
                            ),
                          ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                      child:InkWell(
                        onTap: () {
                          scoreEntered = "5";
                          },
                        child: Ink.image(
                          image: const AssetImage('assets/neutral.png'),
                          // fit: BoxFit.cover,
                          width: 70,
                          height: 70,
                        ),
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                    child:InkWell(
                          onTap: () {
                            scoreEntered = "0";
                          },
                          child: Ink.image(
                            image: const AssetImage('assets/thumbs_down.png'),
                            // fit: BoxFit.cover,
                            width: 70,
                            height: 70,
                          ),
                        ),
                      )
                    ]
                  )
                ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.blue,
                    side: const BorderSide(
                      color: Colors.blue,
                    ),
                  ),
                  onPressed: () {

                    addEntry(JournalEntry(
                        date: dateStr,
                        title: titleController.text,
                        entry: entryController.text,
                        score: scoreEntered
                    ));
                    if (formKey.currentState?.validate() ?? false) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Processing Data')));
                      addEntry(JournalEntry(
                        date: dateStr,
                          title: title,
                          entry: entryController.text,
                        score: scoreEntered
                      ));
                      Navigator.push(
                        context,
                        MaterialPageRoute<HomePage>(
                          builder: (context) => HomePage(firstCamera: firstCamera,),
                        ),
                      );
                    }else{
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('WTF')));
                    }
                  },
                  child: const Text("Submit Entry?"),
              ),
              )
            ],
          ),
        ),
      ),
    );
  }


}
// A screen that allows users to take a picture using a given camera.
class TakePictureScreen extends StatefulWidget {
  const TakePictureScreen({
    super.key,
    required this.camera,
  });

  final CameraDescription camera;

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    // To display the current output from the Camera,
    // create a CameraController.
    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      widget.camera,
      // Define the resolution to use.
      ResolutionPreset.medium,
    );

    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Take a picture')),
      // You must wait until the controller is initialized before displaying the
      // camera preview. Use a FutureBuilder to display a loading spinner until the
      // controller has finished initializing.
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // If the Future is complete, display the preview.
            return CameraPreview(_controller);
          } else {
            // Otherwise, display a loading indicator.
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        // Provide an onPressed callback.
        onPressed: () async {
          // Take the Picture in a try / catch block. If anything goes wrong,
          // catch the error.
          try {
            // Ensure that the camera is initialized.
            await _initializeControllerFuture;

            // Attempt to take a picture and get the file `image`
            // where it was saved.
            final image = await _controller.takePicture();

            if (!mounted) return;

            // If the picture was taken, display it on a new screen.
            await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => DisplayPictureScreen(
                  // Pass the automatically generated path to
                  // the DisplayPictureScreen widget.
                  imagePath: image.path,
                ),
              ),
            );
          } catch (e) {
            // If an error occurs, log the error to the console.
            print(e);
          }
        },
        child: const Icon(Icons.camera_alt),
      ),
    );
  }
}

// A widget that displays the picture taken by the user.
class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;

  const DisplayPictureScreen({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Display the Picture')),
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
      body: Image.file(File(imagePath)),
    );
  }
}

class JournalEntry {
  String date;
  String? title;
  String entry;
  String? score;
  String? picture;

  JournalEntry({
    required this.date,
    this.title,
    required this.entry,
    this.score,
    this.picture,
  });

  factory JournalEntry.fromMap(Map<String, dynamic> data) {
    return JournalEntry(
      date: data['date'],
      title: data['title'],
      entry: data['description'],
      score: data['score'],
      picture: data['picture'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'date' : date,
      'title': title,
      'entry': entry,
      'score': score,
      'picture': picture,
    };
  }
}