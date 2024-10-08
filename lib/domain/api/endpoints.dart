import 'api_key.dart';
import 'base_url.dart';

enum RequestType { get, post, put, patch, delete }

enum EndPoint {
  loadImage,
 
}

// ignore: non_constant_identifier_names
final BASE_URL = API_BaseURL.getBaseURL();

extension URLExtension on EndPoint {
  String get url {
    switch (this) {
      case EndPoint.loadImage:
        return "$BASE_URL/?key=${ApiKey.key}";
     

      default:
        throw Exception(["Endpoint not defined"]);
    }
  }
}

extension RequestMode on EndPoint {
  RequestType get requestType {
    RequestType requestType = RequestType.get;

    switch (this) {
      case EndPoint.loadImage:
        requestType = RequestType.get;
        break;
    
    }
    return requestType;
  }
}

extension Token on EndPoint {
  bool get shouldAddToken {
    var shouldAdd = true;
    switch (this) {
      case EndPoint.loadImage:
        shouldAdd = false;
        break;
        
      default:
        break;
    }

    return shouldAdd;
  }
}
