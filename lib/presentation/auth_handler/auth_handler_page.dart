import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';


import '../capture_image_page/capture_image_page.dart';
import '../google_signup/google_signup_page.dart';

class AuthHandlerPage extends StatelessWidget {
  const AuthHandlerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData == false) {
            return  GoogleSignupScreen();
          } else {
            return ImageCaptureScreen();
          }
        },
      ),
    );
  }
}
