import 'package:dio/dio.dart';
import 'package:mobmovizz/core/network/dio_factory.dart';
import 'package:mobmovizz/core/utils/constants.dart';

class ApiService {
  final Dio _dio;

  ApiService(this._dio);

  Future<Response> get({
    required String endPoint,
    dynamic data,
    dynamic params,
    bool includeBearerToken = true,
    String contentType = applicationJson,
    String? language,
  }) async {
    // Ajouter le paramètre language s'il est fourni
    Map<String, dynamic> finalParams = Map.from(params ?? {});
    if (language != null) {
      finalParams['language'] = language;
    }
    
    var response = await _dio.get('${Constants.apiUrl}$endPoint',
        data: data,
        queryParameters: finalParams,
        options: await _buildOptions(includeBearerToken, contentType));
    return response;
  }

  Future<Response> post({
    required String endPoint,
    dynamic data,
    dynamic params,
    bool includeBearerToken = true,
    String contentType = applicationJson,
    String? language,
  }) async {
    // Ajouter le paramètre language s'il est fourni
    Map<String, dynamic> finalParams = Map.from(params ?? {});
    if (language != null) {
      finalParams['language'] = language;
    }
    
    var response = await _dio.post('${Constants.apiUrl}$endPoint',
        data: data,
        queryParameters: finalParams,
        options: await _buildOptions(includeBearerToken, contentType));
    return response;
  }

  Future<Response> put({
    required String endPoint,
    dynamic data,
    dynamic params,
    bool includeBearerToken = true,
    String contentType = applicationJson,
  }) async {
    var response = await _dio.put('${Constants.apiUrl}$endPoint',
        data: data,
        queryParameters: params,
        options: await _buildOptions(includeBearerToken, contentType));
    return response;
  }
 
  Future<Response> delete({
    required String endPoint,
    bool includeBearerToken = true,
    String contentType = applicationJson,
  }) async {
    var response = await _dio.delete('${Constants.apiUrl}$endPoint',
        options: await _buildOptions(includeBearerToken, contentType));
    return response;
  }

  Future<Options> _buildOptions(bool includeBearerToken, contentType) async {
    // Récupérer le token à partir des préférences partagées
    String? token = Constants.token ;

    // Build request options including the bearer token if necessary
    Map<String, String> headers = {
      'Content-Type': contentType,
      accept: applicationJson,
    };

    // Construire les options de requête en incluant le bearer token si nécessaire
    if (includeBearerToken && (token?.isNotEmpty ?? false)) {
      headers[authorization] = 'Bearer $token';
    }
    return Options(headers: headers);
  }
}
