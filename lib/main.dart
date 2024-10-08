import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'app.dart';
import 'domain/dependency_injection/injectable.dart';
import 'domain/models/image_model.dart';
import 'infrastructure/local_notification.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

// Define a provider for the theme mode
final themeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.system);

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
      child: MyApp(),
    ),
  );
}
