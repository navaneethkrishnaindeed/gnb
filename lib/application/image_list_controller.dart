import 'dart:convert';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:multiple_image_camera/camera_file.dart';
import 'package:multiple_image_camera/multiple_image_camera.dart';
import 'package:path_provider/path_provider.dart';

import '../domain/dependency_injection/injectable.dart';
import '../domain/models/image_model.dart';
import '../domain/models/search_result_model/search_result_model.dart';
import '../infrastructure/image_repo/I_repo.dart';
import '../infrastructure/local_notification.dart';

// Provider for image list (local captures)
final imageListProvider = StateNotifierProvider<ImageListNotifier, List<String>>((ref) => ImageListNotifier());
 UserCredential? currentUserCredential;
class ImageListNotifier extends StateNotifier<List<String>> {
  ImageListNotifier() : super([]);

  void addImages(List<String> newImages) {
    state = [...state, ...newImages];
  }

  void loadImagesFromHive() async {
    final box = await Hive.openBox<ImageModel>('images');
    final loadedImages = box.values.map((model) => model.path).toList();
    state = loadedImages;
  }
}

// Provider for remote photos
final remotePhotosProvider = StateNotifierProvider<RemotePhotosNotifier, List<SearchResultModel>>((ref) => RemotePhotosNotifier());

class RemotePhotosNotifier extends StateNotifier<List<SearchResultModel>> {
  RemotePhotosNotifier() : super([]);
  int _page = 1;
  static const int _limit = 10;
  bool _isLoading = false;

  Future<void> fetchMorePhotos() async {
    if (_isLoading) return;
    _isLoading = true;
    ILoadImageRepo repo = getIt<ILoadImageRepo>();
    List<SearchResultModel> data = [];

    data= await repo.loadImage(nameOfTheImagetoSearch: "lion", page: _page);

    // if (response.statusCode == 200) {
    //   final List<dynamic> data = json.decode(response.body);
    //   final List<Photo> newPhotos = data.map((item) => Photo.fromJson(item)).toList();
      state = [...state, ...data];
      _page++;
    // }

    _isLoading = false;
  }
}

// Provider for image capture
final imageCaptureProvider = Provider((ref) => ImageCapture());

class ImageCapture {
  final ImagePicker _picker = ImagePicker();

  Future<List<String>> captureImages(int count, BuildContext context) async {
    List<MediaModel> imagesMediaModel = [];
    List<String> imagePaths = [];

   XFile? image;
 
   for (int i = 0; i < count; i++) {
  do {
    image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      final String path = await _saveImage(image);
      imagePaths.add(path);
       NotificationService().showNotification(title: "Success",body: "Image added successfully to Local Storage");
    }
  } while (image == null);
}

    return imagePaths;
  }

  Future<String> _saveImage(XFile image) async {
    final directory = await getApplicationDocumentsDirectory();
    final String path = '${directory.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';
    await image.saveTo(path);
    return path;
  }
}
