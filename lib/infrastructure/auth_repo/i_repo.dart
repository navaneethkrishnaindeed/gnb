import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../application/image_list_controller.dart';

class AuthRepo {
//    signinWithGoogle() async {
//     try {
//   log('Attempting Google Sign In...');
//   final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
//   log('Google Sign In completed. User: ${googleUser?.email}');

//   log('Getting Google Auth...');
//   final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
//   log('Google Auth received. Access token: ${googleAuth?.accessToken != null}');

//   log('Creating credential...');
//   final credential = GoogleAuthProvider.credential(
//     accessToken: googleAuth?.accessToken,
//     idToken: googleAuth?.idToken,
//   );
//   log('Credential created.');

//   log('Signing in to Firebase...');
//   await FirebaseAuth.instance.signInWithCredential(credential);
//   log('Firebase Sign In completed.');
// } catch (e) {
//   log('Error during sign in: $e');
//     if (e is FirebaseAuthException) {
//       log('Firebase Auth Error Code: ${e.code}');
//       log('Firebase Auth Error Message: ${e.message}');
//     }

// }
//   }

  signinWithGoogle() async {
    try {
      log('Attempting Google Sign In...');
      final GoogleSignInAccount? googleUser = await GoogleSignIn(forceCodeForRefreshToken: true).signIn();

      if (googleUser == null) {
        log('Google Sign In aborted by user');
        return;
      }

      log('Google Sign In completed. User: ${googleUser.email}');

      log('Getting Google Auth...');
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      log('Google Auth received. Access token: ${googleAuth.accessToken != null}');

      log('Creating credential...');
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      log('Credential created.');

      log('Signing in to Firebase...');
      final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      log('Firebase Sign In completed. User: ${userCredential.user?.email}');
      currentUserCredential = userCredential;
      return userCredential;
    } catch (e) {
      log('Error during sign in: $e');
      if (e is PlatformException) {
        log('PlatformException details:');
        log('  Code: ${e.code}');
        log('  Message: ${e.message}');
        log('  Details: ${e.details}');
      }
      if (e is FirebaseAuthException) {
        log('FirebaseAuthException details:');
        log('  Code: ${e.code}');
        log('  Message: ${e.message}');
      }
    }
  }
}
