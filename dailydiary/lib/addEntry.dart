import 'dart:io';
import 'package:camera/camera.dart';
import 'package:dailydiary/homePage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';
import 'calendar.dart';

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

    if (_selectedImage != null) {
      Reference storageReference = FirebaseStorage.instance.ref().child(
          "images/${_selectedImage!.path + DateTime.now().millisecondsSinceEpoch.toString()}");
      try {
        await storageReference.putFile(_selectedImage!);
        String imageUrl = await storageReference.getDownloadURL();
        newEntry.picture = imageUrl;
      } catch (e) {
        e.toString();
      }
    }

    FirebaseFirestore.instance
        .collection("userData")
        .doc(userId)
        .collection("entry")
        .add(newEntry.toMap());
  }

  @override
  Widget build(BuildContext context) {
    String datePrint = "Journal Date: " + dateStr;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add a new Entry',
            style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 1,
        automaticallyImplyLeading: true,
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  child: Text(
                    datePrint,
                    textAlign: TextAlign.center,
                    style:
                        GoogleFonts.openSans(color: Colors.blue, fontSize: 24),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
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
                      }),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 16),
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
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 16),
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
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 16),
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
                      ]),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  child: _selectedImage != null
                      ? Image.file(_selectedImage!)
                      : Text("Take a picture"),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.blue,
                      side: const BorderSide(
                        color: Colors.blue,
                      ),
                    ),
                    onPressed: () {
                      Calendar cal = new Calendar();
                      print("tryna add smth");
                      cal.addEvent();
                      if (_formKey.currentState?.validate() ?? false) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Processing Data')));
                        addEntry(JournalEntry(
                            date: dateStr,
                            title: titleController.text,
                            entry: entryController.text,
                            score: scoreEntered,
                            picture: "."));
                        titleController.clear();
                        entryController.clear();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => HomePage(
                                  firstCamera: firstCamera,
                                )));
                      } else {
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
          titleController.clear();
          entryController.clear();
          setState(() {
            _selectedImage = null;
          });

        },
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
      'date': date,
      'title': title,
      'entry': entry,
      'score': score,
      'picture': picture,
    };
  }
}
