import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/svg.dart';

import '../../infrastructure/auth_repo/i_repo.dart';
import '../image_gallert.dart';

class AuthHandlerPage extends StatelessWidget {
  const AuthHandlerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData == false) {
            return Scaffold(
              body: Center(
                child: GestureDetector(
                  onTap: () {
                    AuthRepo().signinWithGoogle();
                  },
                  child: SvgPicture.asset(
                    "assets/web_light_rd_ctn.svg",
                    height: 60,
                    width: 400,
                  ),
                ),
              ),
            );
          } else {
            return ImageCaptureScreen();
          }
        },
      ),
    );
  }
}
