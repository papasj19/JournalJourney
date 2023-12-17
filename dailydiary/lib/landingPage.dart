import 'package:flutter/material.dart';
import 'login.dart';
class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPage();
}

class _LandingPage extends State<LandingPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height, //tell the container to take all the space on screen
        width: MediaQuery.of(context).size.width,
        color: const Color(0xff18203d),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // We take the image from the assets
            ClipRRect(
              borderRadius: BorderRadius.circular(20.0), // Adjust the radius of our image as needed
              child: Image.asset(
                'assets/diary_Icon.png',
                height: 250,
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            // Texts and Styling of them
            const Text(
              'Welcome to DailyDiary !',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 28),
            ),
            const SizedBox(height: 20),
            const Text(
              'An app to write everything you want at any time',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            const SizedBox(
              height: 60,
            ),
            // Our MaterialButton which when pressed will take us to a new screen named as
            // LoginScreen
            FractionallySizedBox(
              widthFactor: 0.8, // Set the width factor to 80%

              child: MaterialButton(
                elevation: 0,
                height: 50,
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => LoginScreen()));
                },
                color: Color(0xff25bcbb),
                textColor: Colors.white,
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('Get Started', style: TextStyle(color: Colors.white, fontSize: 20)),
                    Icon(Icons.arrow_forward_ios)
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}