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
  Future<Dio> getDio() async {
    Dio dio = Dio(BaseOptions(
      baseUrl: Constants.apiUrl,
      // receiveTimeout: Constants.apiTimeOut,
      // sendTimeout: Constants.apiTimeOut,
    ));

    if (!kReleaseMode) {
      dio.interceptors.add(PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
      ));
    }

    return dio;
  }
}
