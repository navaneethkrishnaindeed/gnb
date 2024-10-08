
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';


import 'domain/dependency_injection/injectable.dart';
import 'domain/models/image_model.dart';
import 'infrastructure/local_notification.dart';
import 'presentation/auth_handler/auth_handler_page.dart';
import 'presentation/gallery_page/image_gallery.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

// ...


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService().initNotification();
  await Hive.initFlutter();
    
 await configureInjection();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
);
  Hive.registerAdapter(ImageModelAdapter());

  runApp(
    ProviderScope(
      child: MaterialApp(
        home: AuthHandlerPage(),
      ),
    ),
  );
}
