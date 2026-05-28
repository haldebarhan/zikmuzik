import 'package:dio/dio.dart';
import '../config/constants.dart';
import 'interceptors/auth_interceptor.dart';

class DioClient {
  static final Dio _dio = Dio();

  static Dio get instance {
    _dio.options
      ..baseUrl = Constants.baseUrl + Constants.apiVersion
      ..connectTimeout = Constants.timeout
      ..receiveTimeout = Constants.timeout
      ..contentType = 'application/json';

    _dio.interceptors.add(AuthInterceptor());

    // Pour debug
    // _dio.interceptors.add(
    //   LogInterceptor(responseBody: true, requestBody: true),
    // );

    return _dio;
  }
}
