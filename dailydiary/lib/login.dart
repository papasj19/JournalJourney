import 'package:camera/camera.dart';
import 'package:dailydiary/homePage.dart';
import 'package:dailydiary/register.dart';
import 'package:dailydiary/resetPassword.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebaseAuthentif;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginScreen extends StatelessWidget {
  final Color primaryColor = Color(0xff18203d);
  final Color secondaryColor = Color(0xff232c51);

  final Color logoGreen = Color(0xff25bcbb);

  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final CameraDescription firstCamera;

  LoginScreen({super.key, required this.firstCamera});
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<firebaseAuthentif.User?>(
      stream: firebaseAuthentif.FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              automaticallyImplyLeading: false,
            ),
            backgroundColor: primaryColor,
            body: Container(
              alignment: Alignment.topCenter,
              margin: const EdgeInsets.symmetric(horizontal: 30),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Sign in to DailyDiary and continue',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.openSans(
                          color: Colors.white, fontSize: 28),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Enter your email and password below to continue and enter you diary!',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.openSans(
                          color: Colors.white, fontSize: 14),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    _buildTextField(
                      nameController,
                      Icons.email,
                      'Email',
                    ),
                    const SizedBox(height: 20),
                    _buildTextField(
                      passwordController,
                      Icons.lock,
                      'Password',
                      obscureText: true,
                    ),
                    const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      MaterialButton(
                        elevation: 0,
                        onPressed: (){
                          Navigator.push(
                            context,
                            MaterialPageRoute<Register>(
                              builder: (context) => Register(firstCamera: firstCamera,),
                            ),
                          );
                        },
                        child: const Text('No account yet?',
                            style: TextStyle(color: Colors.white, fontSize: 12)),
                      ),
                      MaterialButton(
                      elevation: 0,
                      onPressed: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute<ResetPassword>(
                            builder: (context) => ResetPassword(firstCamera: firstCamera,),
                          ),
                        );
                      },
                        child: const Text('Forgotten password?',
                            style: TextStyle(color: Colors.red, fontSize: 12)),
                      ),
                    ],
                  ),
                    const SizedBox(height: 20),
                    MaterialButton(
                      elevation: 0,
                      minWidth: double.maxFinite,
                      height: 50,
                      onPressed: () async {
                        BuildContext currentContext =
                            context; // Capture the context
                        if(nameController.text == "" || passwordController.text =="") {
                          ScaffoldMessenger.of(currentContext).showSnackBar(
                            SnackBar(
                              content: Text('Please complete both fields'),
                              backgroundColor: Colors.red,
                            ),
                          );
                          return;
                        }
                        try {
                          // Your asynchronous code
                          await FirebaseAuth.instance
                              .signInWithEmailAndPassword(
                            email: nameController.text,
                            password: passwordController.text,
                          );

                          // Use the captured context for UI updates if needed
                          ScaffoldMessenger.of(currentContext).showSnackBar(
                            const SnackBar(
                              content: Text('Sign-in successful'),
                              backgroundColor: Colors.green,
                            ),
                          );
                          nameController.clear();
                          passwordController.clear();
                        } on FirebaseAuthException catch (e) {
                          ScaffoldMessenger.of(currentContext).showSnackBar(
                            const SnackBar(
                              content: Text('The provided username or password is incorrect'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        } catch (e) {
                          // Handle other exceptions
                          ScaffoldMessenger.of(currentContext).showSnackBar(
                            SnackBar(
                              content: Text('Unexpected error: $e'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      },
                      color: logoGreen,
                      textColor: Colors.white,
                      child: const Text('Login',
                          style: TextStyle(color: Colors.white, fontSize: 16)),
                    ),
                    const SizedBox(height: 20),
                    MaterialButton(
                      elevation: 0,
                      minWidth: double.maxFinite,
                      height: 50,
                      onPressed: () async {
                        try {
                          // Call the Google sign-in method
                          await signInWithGoogle();
                          // Handle successful Google sign-in
                        } catch (e) {
                          e.toString();
                          // Handle Google sign-in error
                        }
                      },
                      color: Colors.blue,
                      textColor: Colors.white,
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(FontAwesomeIcons.google),
                          SizedBox(width: 10),
                          Text('Sign-in using Google',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 100),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: _buildFooterLogo(),
                    )
                  ],
                ),
              ),
            ),
          );
        }
        return HomePage(firstCamera: firstCamera);
      },
    );
  }

  _buildFooterLogo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text('The Best App For You',
            textAlign: TextAlign.center,
            style: GoogleFonts.openSans(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold)),
      ],
    );
  }

  Future<UserCredential?> signInWithGoogle() async {
    try {
      // Trigger the Google sign-in process
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        // User canceled the Google sign-in
        return null;
      }

      // Obtain the GoogleSignInAuthentication object
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create a new GoogleAuthProvider credential
      final firebaseAuthentif.OAuthCredential credential =
          GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google credentials
      return await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      e.toString();
      return null;
    }
  }

  _buildTextField(
      TextEditingController controller,
      IconData icon,
      String labelText,
      {bool obscureText = false}
      ) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: secondaryColor,
        border: Border.all(color: Colors.blue),
      ),
      child: TextFormField(
        controller: controller,
        style: TextStyle(color: Colors.white),
        obscureText: obscureText,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 10),
          labelText: labelText,
          labelStyle: TextStyle(color: Colors.white),
          icon: Icon(
            icon,
            color: Colors.white,
          ),
          // prefix: Icon(icon),
          border: InputBorder.none,
        ),
      ),
    );
  }

}
