class AppException implements Exception {
  // ignore: unused_field, prefer_typing_uninitialized_variables
  final _message;
  // ignore: unused_field, prefer_typing_uninitialized_variables
  final _prefix;

  AppException([this._message, this._prefix]);

  @override
  String toString() {
    return "$_message";
  }
}

class FetchDataException extends AppException {
  FetchDataException([String? message]) : super(message, "");
}

class BadRequestException extends AppException {
  BadRequestException([message]) : super(message, "Invalid Request. ");
}

class UnauthorisedException extends AppException {
  UnauthorisedException([message]) : super(message, "Unauthorised. ");
}

class InvalidInputException extends AppException {
  InvalidInputException([String? message]) : super(message, "Invalid Input. ");
}

class NotFoundException extends AppException {
  NotFoundException([String? message]) : super(message, "Not Found. ");
}

class InternetErrorException extends AppException {
  InternetErrorException([String? message]) : super(message, "Please check your internet connection");
}

class InternalServerException extends AppException {
  InternalServerException([String? message])
      : super(message, "Internal Server Error. ");
}
