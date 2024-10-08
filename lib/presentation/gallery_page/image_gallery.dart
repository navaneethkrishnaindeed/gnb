import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gnb/domain/constants/strings/gallery_strings.dart';


import '../../application/image_list_controller.dart';

class ImageGalleryScreen extends ConsumerStatefulWidget {
  @override
  _ImageGalleryScreenState createState() => _ImageGalleryScreenState();
}

class _ImageGalleryScreenState extends ConsumerState<ImageGalleryScreen> with GalleryStrings{
  @override
  void initState() {
    ref.read(remotePhotosProvider.notifier).fetchMorePhotos();

    super.initState();
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      appBar: AppBar(title:  Text(title)),
      body: ImageListView(),
    );
  }
}

class ImageListView extends ConsumerWidget with GalleryStrings{
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localImages = ref.watch(imageListProvider);
    final remotePhotos = ref.watch(remotePhotosProvider);

    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification scrollInfo) {
        if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
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
                  RemoteImageWidget(imageUrl: photo.largeImageURL,scale: 1,),
                  Text(
                    photo.pageURL.toString(),
                    textAlign: TextAlign.center,
                  ),
                  Text('$id ${photo.id}'),
                ],
              ),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}

class RemoteImageWidget extends StatelessWidget {
  final String imageUrl;
  final double scale;

  const RemoteImageWidget({Key? key, required this.imageUrl,required this.scale}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.network(
      
      imageUrl,
      scale: scale,
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
        return const Icon(Icons.error);
      },
    );
  }
}
