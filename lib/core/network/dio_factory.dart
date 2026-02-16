import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:mobmovizz/core/utils/constants.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

const String applicationJson = "application/json";
const String multipartFormData = "multipart/form-data";
const String contentType = "Content-Type";
const String accept = "Accept";
const String authorization = "Authorization";
const String defaultLanguage = "language";

class DioFactory {
  static const Duration _connectTimeout = Duration(seconds: 30);
  static const Duration _receiveTimeout = Duration(seconds: 30);
  static const Duration _sendTimeout = Duration(seconds: 30);

  Future<Dio> getDio() async {
    Dio dio = Dio(BaseOptions(
      baseUrl: Constants.apiUrl,
      connectTimeout: _connectTimeout,
      receiveTimeout: _receiveTimeout,
      sendTimeout: _sendTimeout,
    ));

    if (!kReleaseMode) {
      dio.interceptors.add(PrettyDioLogger(
        requestHeader: false,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
      ));
    }

    return dio;
  }
}
