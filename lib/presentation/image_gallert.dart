import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gnb/infrastructure/local_notification.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import '../application/image_list_controller.dart';
import '../domain/models/image_model.dart';

class ImageCaptureScreen extends ConsumerStatefulWidget {
  @override
  _ImageCaptureScreenState createState() => _ImageCaptureScreenState();
}

class _ImageCaptureScreenState extends ConsumerState<ImageCaptureScreen> {
  @override
  void initState() {
    super.initState();
    ref.read(imageListProvider.notifier).loadImagesFromHive();
  }

  @override
  Widget build(BuildContext context) {
    final localImages = ref.watch(imageListProvider);

    return Scaffold(
      appBar: AppBar(title: Text('Image Capture')),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () async {
              final count = await _showImageCountDialog(context);
              if (count != null) {
                final imagePaths = await ref.read(imageCaptureProvider).captureImages(count, context);
                ref.read(imageListProvider.notifier).addImages(imagePaths);

                // Save to Hive
                final box = await Hive.openBox<ImageModel>('images');
                for (final path in imagePaths) {
                  await box.add(ImageModel(path));
                }
              }
            },
            child:const Text('Capture Images'),
          ),
         
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(maxCrossAxisExtent: 330,mainAxisSpacing: 30,),
              itemCount: localImages.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Image.file(
                    File(localImages[index]),
                    fit: BoxFit.cover,
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ImageGalleryScreen(),
          ));
        },
        child:const Icon(Icons.photo_library),
        tooltip: 'View Gallery',
      ),
    );
  }

  Future<int?> _showImageCountDialog(BuildContext context) async {
    return showDialog<int>(
      context: context,
      builder: (BuildContext context) {
        int count = 1;
        return AlertDialog(
          title: Text('Number of Images'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Container(
                height: 300,
                child: Row(
                  children: [
                    Text('Count: $count'),
                    Slider(
                      value: count.toDouble(),
                      min: 1,
                      max: 10,
                      divisions: 9,
                      onChanged: (double value) {
                        setState(() {
                          count = value.round();
                        });
                      },
                    ),
                  ],
                ),
              );
            },
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text('OK'),
              onPressed: () => Navigator.of(context).pop(count),
            ),
          ],
        );
      },
    );
  }
}

class ImageGalleryScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: Text('Image Gallery')),
      body: ImageListView(),
    );
  }
}

class ImageListView extends ConsumerWidget {
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
              // ref.read(remotePhotosProvider.notifier).fetchMorePhotos();

    final localImages = ref.watch(imageListProvider);
    final remotePhotos = ref.watch(remotePhotosProvider);

    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification scrollInfo) {
        if (scrollInfo.metrics.pixels== scrollInfo.metrics.maxScrollExtent) {
          ref.read(remotePhotosProvider.notifier).fetchMorePhotos();
        }
        return true;
      },
      child: ListView.builder(
        itemCount: localImages.length + remotePhotos.length + 1,
        itemBuilder: (context, index) {
          if (index < localImages.length) {
            return Image.file(File(localImages[index]));
          } else if (index < localImages.length + remotePhotos.length) {
            final photo = remotePhotos[index - localImages.length];
            return Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  RemoteImageWidget(imageUrl: photo.largeImageURL),
                  Text(photo.pageURL.toString(),textAlign: TextAlign.center,),
                  Text('ID: ${photo.id}'),
                ],
              ),
            );
            
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}

class RemoteImageWidget extends StatelessWidget {
  final String imageUrl;

  const RemoteImageWidget({Key? key, required this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.network(
      imageUrl,
   
      fit: BoxFit.cover,
      loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
        if (loadingProgress == null) return child;
        return SizedBox(
          height: 250,
          child: Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes! : null,
            ),
          ),
        );
      },
      errorBuilder: (context, error, stackTrace) {
        return Icon(Icons.error);
      },
    );
  }
}
