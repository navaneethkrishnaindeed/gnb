
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
part 'image_model.g.dart';


@HiveType(typeId: 0)
class ImageModel extends HiveObject {
  @HiveField(0)
  late String path;

  ImageModel(this.path);
}

// Hive type adapter for ImageModel
// class ImageModelAdapter extends TypeAdapter<ImageModel> {
//   @override
//   final int typeId = 0;

//   @override
//   ImageModel read(BinaryReader reader) {
//     final path = reader.readString();
//     return ImageModel(path);
//   }

//   @override
//   void write(BinaryWriter writer, ImageModel obj) {
//     writer.writeString(obj.path);
//   }
// }

// Model for remote photos
class Photo {
  final int id;
  final String title;
  final String url;
  final String thumbnailUrl;

  Photo({required this.id, required this.title, required this.url, required this.thumbnailUrl});

  factory Photo.fromJson(Map<String, dynamic> json) {
    return Photo(
      id: json['id'],
      title: json['title'],
      url: json['url'],
      thumbnailUrl: json['thumbnailUrl'],
    );
  }
}
