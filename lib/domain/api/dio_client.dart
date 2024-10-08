// ignore_for_file: non_constant_identifier_names

import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../constants/debug_status.dart';
import 'endpoints.dart';
import 'exceptions.dart';

class DioClient {
  final Dio _dio;
  DioClient(this._dio) {
    initialiseDio();
  }
  initialiseDio() {
    _dio.options = BaseOptions(
      responseType: ResponseType.json,
      connectTimeout: 8000,
      contentType: Headers.jsonContentType,
      followRedirects: false,
      validateStatus: (status) {
        if (status != null) {
          return status < 500;
        } else {
          return false;
        }
      },
    );
    if (DebugStatus.IS_DEBUG) {
      _dio.interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseBody: true,
          responseHeader: true,
          error: true,
          compact: false,
          maxWidth: 100,
          logPrint: (object) => print(object.toString()),
        ),
      );
    }
  }

  Future<Response> request({required EndPoint endPoint, dynamic data, Map<String, dynamic>? queryParams, String urlParams = ""}) async {
    late Response response;

    try {
      switch (endPoint.requestType) {
        case RequestType.get:
          response = await _dio.get(endPoint.url + urlParams, queryParameters: data ?? queryParams);
          break;
        case RequestType.post:
          response = await _dio.post(endPoint.url + urlParams, data: data, queryParameters: queryParams);
          break;
        case RequestType.patch:
          response = await _dio.patch(endPoint.url + urlParams, data: data, queryParameters: queryParams);
          break;
        case RequestType.put:
          response = await _dio.put(endPoint.url + urlParams, data: data, queryParameters: queryParams);
          break;

        case RequestType.delete:
          response = await _dio.delete(endPoint.url + urlParams, data: data);
      }
    } on DioError catch (error) {
      switch (error.type) {
        case DioErrorType.connectTimeout:
        case DioErrorType.sendTimeout:
        case DioErrorType.receiveTimeout:
          throw FetchDataException('Timeout Error\n\n${error.message}');

        case DioErrorType.response:
          response = error.response!; // If response is available.
          break;
        case DioErrorType.cancel:
          throw FetchDataException('Request Cancelled\n\n${error.message}');
        case DioErrorType.other:
          String message = error.message.contains('SocketException') ? "No Internet Connection" : "Oops, Something went wrong";
          kDebugMode ? throw FetchDataException('$message\n\n${error.message}') : throw FetchDataException(message);
      }
    }
    return response;
  }
}

class ApiResponse<T> {
  ApiResponseStatus status;
  T? data;
  String? message;
  ApiResponse.idle() : status = ApiResponseStatus.idle;
  ApiResponse.loading(this.message) : status = ApiResponseStatus.loading;
  ApiResponse.completed(this.data) : status = ApiResponseStatus.completed;
  ApiResponse.unProcessable(this.message) : status = ApiResponseStatus.unProcessable;
  ApiResponse.error(this.message) : status = ApiResponseStatus.error;
  @override
  String toString() {
    return "ApiResponseStatus : $status \n Message : $message \n Data : $data";
  }
}

enum ApiResponseStatus { idle, loading, completed, unProcessable, error }
