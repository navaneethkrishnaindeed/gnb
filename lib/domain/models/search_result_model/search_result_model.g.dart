// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_result_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SearchResultModelImpl _$$SearchResultModelImplFromJson(
        Map<String, dynamic> json) =>
    _$SearchResultModelImpl(
      id: json['id'] as num,
      pageURL: json['pageURL'] as String,
      type: json['type'] as String,
      tags: json['tags'] as String,
      previewURL: json['previewURL'] as String,
      previewWidth: json['previewWidth'] as num,
      previewHeight: json['previewHeight'] as num,
      webformatURL: json['webformatURL'] as String,
      webformatWidth: json['webformatWidth'] as num,
      webformatHeight: json['webformatHeight'] as num,
      largeImageURL: json['largeImageURL'] as String,
      imageWidth: json['imageWidth'] as num,
      imageHeight: json['imageHeight'] as num,
      imageSize: json['imageSize'] as num,
      views: json['views'] as num,
      downloads: json['downloads'] as num,
      collections: json['collections'] as num,
      likes: json['likes'] as num,
      comments: json['comments'] as num,
      user_id: json['user_id'] as num,
      user: json['user'] as String,
      userImageURL: json['userImageURL'] as String,
    );

Map<String, dynamic> _$$SearchResultModelImplToJson(
        _$SearchResultModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'pageURL': instance.pageURL,
      'type': instance.type,
      'tags': instance.tags,
      'previewURL': instance.previewURL,
      'previewWidth': instance.previewWidth,
      'previewHeight': instance.previewHeight,
      'webformatURL': instance.webformatURL,
      'webformatWidth': instance.webformatWidth,
      'webformatHeight': instance.webformatHeight,
      'largeImageURL': instance.largeImageURL,
      'imageWidth': instance.imageWidth,
      'imageHeight': instance.imageHeight,
      'imageSize': instance.imageSize,
      'views': instance.views,
      'downloads': instance.downloads,
      'collections': instance.collections,
      'likes': instance.likes,
      'comments': instance.comments,
      'user_id': instance.user_id,
      'user': instance.user,
      'userImageURL': instance.userImageURL,
    };
