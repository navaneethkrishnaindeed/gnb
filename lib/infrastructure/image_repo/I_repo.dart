
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';


import '../../domain/api/dio_client.dart';
import '../../domain/api/endpoints.dart';
import '../../domain/api/exceptions.dart';
import '../../domain/models/search_result_model/search_result_model.dart';

abstract class ILoadImageRepo {
loadImage({required String nameOfTheImagetoSearch, required int page});
}

@LazySingleton(as: ILoadImageRepo)
class LoadImageRepoImpl implements ILoadImageRepo {
  @override
  loadImage({required String nameOfTheImagetoSearch,required int page}) async {
    DioClient dio = DioClient(Dio());

    try {
      final response = await dio.request(endPoint: EndPoint.loadImage, queryParams: {"q": nameOfTheImagetoSearch, "image_type": "photo","page":page,"per_page":40});

      if (response.statusCode == 200 || response.statusCode == 201) {
        
        final datas = (response.data['hits'] as List).map((e) {
          return SearchResultModel.fromJson(e);
        }).toList();

        print(datas[1]);
        return datas;
      } else {
        throw InternalServerException();
      }
    } catch (e) {
       throw AppException();
    }
  }

}
