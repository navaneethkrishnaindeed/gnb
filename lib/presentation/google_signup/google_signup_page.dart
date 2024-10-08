
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../domain/constants/strings/gallery_strings.dart';
import '../../infrastructure/auth_repo/i_repo.dart';

class GoogleSignupScreen extends StatelessWidget with GalleryStrings{
   GoogleSignupScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Padding(
              padding: const EdgeInsets.all(70.0),
              child: Image.asset(logoPath),
            ),
            GestureDetector(
              onTap: () {
                AuthRepo().signinWithGoogle();
              },
              child: SvgPicture.asset(
                googleButton,
                height: 60,
                width: 400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
