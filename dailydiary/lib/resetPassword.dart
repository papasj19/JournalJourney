import 'package:dailydiary/homePage.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebaseAuthentif;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ResetPassword extends StatelessWidget{
  final Color primaryColor = Color(0xff18203d);
  final Color secondaryColor = Color(0xff232c51);

  final Color logoGreen = Color(0xff25bcbb);

  final TextEditingController emailController = TextEditingController();

  ResetPassword({super.key});
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
              iconTheme: const IconThemeData(color:Colors.white),
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
                    const SizedBox(height: 30),
                    Text(
                      'Reset your password',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.openSans(
                          color: Colors.white, fontSize: 28),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Enter your email address and we will send you an email with the instruction to retrieve your password!',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.openSans(
                          color: Colors.white, fontSize: 14),
                    ),
                  const SizedBox(height:70),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: secondaryColor,
                      border: Border.all(color: Colors.blue),
                    ),
                    child: TextFormField(
                      controller: emailController,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 10),
                        labelText: 'Mail',
                        labelStyle: TextStyle(color: Colors.white),
                        icon: Icon(
                          Icons.email,
                          color: Colors.white,
                        ),
                        // prefix: Icon(icon),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                    const SizedBox(height: 30),
                    MaterialButton(
                      elevation: 0,
                      minWidth: double.maxFinite,
                      height: 50,
                      onPressed: () async {
                        BuildContext currentContext =
                            context; // Capture the context
                        if(emailController.text == "") {
                          ScaffoldMessenger.of(currentContext).showSnackBar(
                            const SnackBar(
                              content: Text('Please complete the field'),
                              backgroundColor: Colors.red,
                            ),
                          );
                          return;
                        }
                        try {
                          // Your asynchronous code
                          await FirebaseAuth.instance
                              .sendPasswordResetEmail(
                            email: emailController.text,
                          );

                          // Use the captured context for UI updates if needed
                          ScaffoldMessenger.of(currentContext).showSnackBar(
                            const SnackBar(
                              content: Text('Email sent! Please check your MailBox'),
                              backgroundColor: Colors.green,
                            ),
                          );
                          emailController.clear();
                        } on FirebaseAuthException catch (e) {
                          ScaffoldMessenger.of(currentContext).showSnackBar(
                            const SnackBar(
                              content: Text('Error from Firebase'),
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
                      child: const Text('Reset'
                          '',
                          style: TextStyle(color: Colors.white, fontSize: 16)),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          );
        }
        return const HomePage();
      },
    );
  }
}
