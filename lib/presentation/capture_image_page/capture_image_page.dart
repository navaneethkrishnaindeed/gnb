import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gnb/domain/constants/strings/capture_image_strings.dart';
import 'package:gnb/presentation/gallery_page/image_gallery.dart';
import 'package:gnb/presentation/profile_page/profile_page.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../application/image_list_controller.dart';
import '../../domain/models/image_model.dart';

class ImageCaptureScreen extends ConsumerStatefulWidget {
  @override
  _ImageCaptureScreenState createState() => _ImageCaptureScreenState();
}

class _ImageCaptureScreenState extends ConsumerState<ImageCaptureScreen> with CaptureImageStrings{
  @override
  void initState() {
    super.initState();
    ref.read(imageListProvider.notifier).loadImagesFromHive();
  }

  @override
  Widget build(BuildContext context) {
    final localImages = ref.watch(imageListProvider);

    return Scaffold(
      appBar: AppBar(
        title:  Text(title),
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) {
                return ProfilePage();
              },
            ));
          },
          child: const Icon(
            Icons.account_circle,
            size: 40,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            localImages.isEmpty
                ?  Expanded(child: Center(child: Text(noDataAwailable)))
                : Expanded(
                    child: GridView.builder(
                      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 330,
                        mainAxisSpacing: 30,
                      ),
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
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
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
            child: const Icon(Icons.add_a_photo_rounded),
          ),
          const SizedBox(
            height: 30,
          ),
          FloatingActionButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => ImageGalleryScreen(),
              ));
            },
           
            child: const Icon(Icons.photo_library),
          ),
        ],
      ),
    );
  }

  Future<int?> _showImageCountDialog(BuildContext context) async {
    return showDialog<int>(
      context: context,
      builder: (BuildContext context) {
        int count = 1;
        return AlertDialog(
          title: Text(numberOfImages),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Container(
                height: 300,
                child: Row(
                  children: [
                    Text('$countText $count'),
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
              child: Text(cancel),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text(ok),
              onPressed: () => Navigator.of(context).pop(count),
            ),
          ],
        );
      },
    );
  }
}
