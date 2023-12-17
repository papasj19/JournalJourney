import 'package:dailydiary/homePage.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebaseAuthentif;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Register extends StatelessWidget {
  Register({super.key});

  final Color primaryColor = Color(0xff18203d);
  final Color secondaryColor = Color(0xff232c51);

  final Color logoGreen = Color(0xff25bcbb);

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
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
                iconTheme: const IconThemeData(color: Colors.white),
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
                        'Create Account',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.openSans(
                            color: Colors.white, fontSize: 28),
                      ),
                      const SizedBox(height:20),
                      const Icon(
                        Icons.account_circle,
                        color: Colors.white,
                        size: 150,
                      ),
                      const SizedBox(height:50),
                      _buildTextField(
                        emailController,
                        Icons.email,
                        'Email',
                      ),
                      const SizedBox(height: 20),
                      _buildTextField(
                        passwordController,
                        Icons.lock,
                        'Password',
                        obscureText : true
                      ),
                      const SizedBox(height: 20),
                      _buildTextField(
                          confirmPasswordController,
                          Icons.lock,
                          'Confirm Password',
                          obscureText : true
                      ),
                      const SizedBox(height: 50),
                      MaterialButton(
                        elevation: 0,
                        color: logoGreen,
                        minWidth: double.maxFinite,
                        height: 50,
                        onPressed: () async {
                          BuildContext currentContext =
                              context; // Capture the context
                          if(emailController.text == "" || passwordController.text =="" || confirmPasswordController.text == "") {
                            ScaffoldMessenger.of(currentContext).showSnackBar(
                              const SnackBar(
                                content: Text('Please complete all the fields'),
                                backgroundColor: Colors.red,
                              ),
                            );
                            return;
                          } else if(passwordController.text != confirmPasswordController.text){
                            ScaffoldMessenger.of(currentContext).showSnackBar(
                              const SnackBar(
                                content: Text('The password confirmation does not match'),
                                backgroundColor: Colors.red,
                              ),
                            );
                            return;
                          } else if(passwordController.text.length < 6){
                            ScaffoldMessenger.of(currentContext).showSnackBar(
                              const SnackBar(
                                content: Text('The password should have at least 6 character'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                          else {
                            try{
                              await FirebaseAuth.instance
                                  .createUserWithEmailAndPassword(
                                email: emailController.text,
                                password: passwordController.text,
                              );

                              ScaffoldMessenger.of(currentContext).showSnackBar(
                                const SnackBar(
                                  content: Text('Account created successfully'),
                                  backgroundColor: Colors.green,
                                ),
                              );
                              emailController.clear();
                              passwordController.clear();
                              confirmPasswordController.clear();
                            } on FirebaseException catch (e){
                              print(e.message);
                            }
                          }
                        },
                        child: const Text('Register',
                            style: TextStyle(color: Colors.white, fontSize: 20)),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
          return const HomePage();
        });
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
