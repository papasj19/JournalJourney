import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
class AddEntry extends StatelessWidget{
  final CameraDescription firstCamera;

  const AddEntry({super.key, required this.firstCamera});

  @override
  Widget build(BuildContext context) {
    var entryController = TextEditingController();
    var titleController = TextEditingController();
    var moodController = TextEditingController();
    var submitController = TextEditingController();
    DateTime today = DateTime.now();
    String dateStr = "${today.day}-${today.month}-${today.year}";
    var title;

    var score;
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
                    labelText: 'Give Your It A Title?',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child:TextFormField(
                    controller: entryController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please complete the form';
                    }
                    return null;
                  },
                    decoration: const InputDecoration(
                      labelText: 'Your Entry Goes Here',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 8,
                    minLines: 3,
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
                              score = 10;
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
                          score = 5;
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
                            score = 0;
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
                  onPressed: () {},
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