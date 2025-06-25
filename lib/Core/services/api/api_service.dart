import 'package:dio/dio.dart';

class ApiService {
  final Dio dio;

  ApiService({Dio? dio}) : dio = dio ?? Dio();

  Future<Response> post(
    String url, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    return dio.post(
      url,
      data: data,
      queryParameters: queryParameters,
      options: Options(headers: headers),
    );
  }

}
