import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gnb/application/image_list_controller.dart';
import 'package:gnb/domain/utils/screen_sizes.dart';

import '../../domain/constants/strings/profile_page_strings.dart';
import '../gallery_page/image_gallery.dart';

class ProfilePage extends StatelessWidget with ProfilePageStrings {
  ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          width: ScreenSizes(context).screenWidth(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(30),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: const Icon(Icons.arrow_back_ios),
                    ),
                  ),
                  const Spacer()
                ],
              ),
              SizedBox(
                height: ScreenSizes(context).screenHeightFraction(percent: 10),
              ),
              StreamBuilder(
                  stream: FirebaseAuth.instance.authStateChanges(),
                  builder: (context, snap) {
                    return SizedBox(
                      width: ScreenSizes(context).screenWidthFraction(percent: 80),
                      child: Column(
                        children: [
                          ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: RemoteImageWidget(
                                scale: 0.4,
                                imageUrl: snap.data?.photoURL ?? placeHolder,
                              )),
                          SizedBox(
                            height: ScreenSizes(context).screenHeightFraction(percent: 7),
                          ),
                          Row(
                            children: [
                              Text(userId),
                              SizedBox(
                                width: ScreenSizes(context).screenWidthFraction(percent: 5),
                              ),
                              Text(snap.data?.uid ?? emptyData),
                            ],
                          ),
                          Row(
                            children: [
                              Text(name),
                              SizedBox(
                                width: ScreenSizes(context).screenWidthFraction(percent: 5),
                              ),
                              Text(snap.data?.displayName ?? emptyData),
                            ],
                          ),
                          Row(
                            children: [
                              Text(email),
                              SizedBox(
                                width: ScreenSizes(context).screenWidthFraction(percent: 5),
                              ),
                              Text(snap.data?.email ?? emptyData),
                            ],
                          ),
                          SizedBox(
                            height: ScreenSizes(context).screenHeightFraction(percent: 20),
                          ),
                          ElevatedButton(
                              onPressed: () async {
                                await FirebaseAuth.instance.signOut();
                                Navigator.pop(context);
                              },
                              child: Text(
                                logout,
                                style: const TextStyle(fontSize: 18),
                              )),
                        ],
                      ),
                    );
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
