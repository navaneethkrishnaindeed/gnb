import 'package:freezed_annotation/freezed_annotation.dart';
part 'search_result_model.g.dart';
part 'search_result_model.freezed.dart';
@freezed
class SearchResultModel with _$SearchResultModel{
  const factory SearchResultModel({
    required num id,
    required String pageURL,
    required String type,
    required String tags,
    required String previewURL,
    required num previewWidth,
    required num previewHeight,
    required String webformatURL,
    required num webformatWidth,
    required num webformatHeight,
    required String largeImageURL,
    required num imageWidth,
    required num imageHeight,
    required num imageSize,
    required num views,
    required num downloads,
    required num collections,
    required num likes,
    required num comments,
    required num user_id,
    required String user,
    required String userImageURL,

  }) = _SearchResultModel;

    factory SearchResultModel.fromJson(Map<String, dynamic> json) => _$SearchResultModelFromJson(json);

}