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
import 'package:image_picker/image_picker.dart';

class AddEntry extends StatefulWidget {
  final CameraDescription firstCamera;

  const AddEntry({Key? key, required this.firstCamera}) : super(key: key);

  @override
  _AddEntryState createState() => _AddEntryState();
}

class _AddEntryState extends State<AddEntry> {
  final _formKey = GlobalKey<FormState>();
  late CameraDescription firstCamera;
  late TextEditingController entryController;
  late TextEditingController titleController;
  late TextEditingController moodController;
  late DateTime today;
  late String dateStr;
  late String title;
  File? _selectedImage;
  late String scoreEntered;

  @override
  void initState() {
    super.initState();
    firstCamera = widget.firstCamera;
    entryController = TextEditingController();
    titleController = TextEditingController();
    moodController = TextEditingController();
    today = DateTime.now();
    dateStr = "${today.day}-${today.month}-${today.year}";
    title = '';
    scoreEntered = '3';
  }

  Future<void> _pickImage() async {
    final selected = await ImagePicker().pickImage(source: ImageSource.camera);

    if (selected == null) return;

    setState(() {
      _selectedImage = File(selected.path);
    });
  }


  void addEntry(JournalEntry newEntry) async {
    User? currentUser = await FirebaseAuth.instance.currentUser;
    String? userId = currentUser?.uid;

    FirebaseFirestore.instance
        .collection("userData")
        .doc(userId)
        .collection("entry")
        .add(newEntry.toMap());
  }

  void pushHome(CameraDescription cam) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HomePage(firstCamera: cam),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String datePrint = "Journal Date: " + dateStr;

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
              _pickImage();
            },
          )
        ],
      ),
      body: Container(
        alignment: Alignment.topCenter,
        margin: const EdgeInsets.symmetric(horizontal: 30),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
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
                    ),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Make sure to add a title for your entry!';
                      }
                      return null;
                    },
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  child: TextFormField(
                      controller: entryController,
                      decoration: const InputDecoration(
                        labelText: 'Your Entry Goes Here',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 8,
                      minLines: 3,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
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
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                scoreEntered = "10";
                              });
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
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                scoreEntered = "5";
                              });
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
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                scoreEntered = "0";
                              });
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
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  child: ElevatedButton(
                    child: Text("Tmp for Voice"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueGrey,
                      foregroundColor: Colors.white,
                      elevation: 0,
                    ),
                    onPressed: () {},
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  child: _selectedImage != null ? Image.file(_selectedImage!): Text("Take a picture"),
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

                      if (_formKey.currentState?.validate() ?? false) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Processing Data')));
                        addEntry(JournalEntry(
                            date: dateStr,
                            title: titleController.text,
                            entry: entryController.text,
                            score: scoreEntered,
                            picture: "."
                        ));
                        titleController.clear();
                        entryController.clear();
                        pushHome(firstCamera);
                      }else{
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Please Complete Form')));
                      }
                    },
                    child: const Text("Submit Entry?"),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.delete),
        onPressed: () {
          // Access the firstCamera from the CameraProvider
          Navigator.push(context, MaterialPageRoute(builder: (_) => HomePage(firstCamera: firstCamera,)));
        },
      ),
    );
  }
}

// ... (rest of the code remains unchanged)

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
          /*
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
          }*/
        },
        child: const Icon(Icons.camera_alt),
      ),

    );
  }
}

// A widget that displays the picture taken by the user.
class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;

  DisplayPictureScreen({required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Display Picture')),
      body: Column(
        children: [
          // Display the image
          Image.file(File(imagePath)),

          // Add validation and go back buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                onPressed: () {
                  // Implement validation logic here
                  // For example, you can show a success message or perform an action.
                  // For now, let's print a message.
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: Text('Validate'),
              ),
              ElevatedButton(
                onPressed: () {
                  // Go back to the camera screen
                  Navigator.pop(context);
                },
                child: Text('Go Back'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class JournalEntry {
  String date;
  String title;
  String entry;
  String score;
  String picture;

  JournalEntry({
    required this.date,
    required this.title,
    required this.entry,
    required this.score,
    required this.picture,
  });

  factory JournalEntry.fromSnap(DocumentSnapshot<Map<String, dynamic>> data) {
    return JournalEntry(
      date: data.data()!["date"],
      title: data.data()!['title'],
      entry: data.data()!['description'],
      score: data.data()!['score'],
      picture: data.data()!['picture'],
    );
  }

  factory JournalEntry.fromMap(Map<String, dynamic> data) {
    return JournalEntry(
      date: data["date"].toString(),
      title: data['title'].toString(),
      entry: data['entry'].toString(),
      score: data['score'].toString(),
      picture: data['picture'].toString(),
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