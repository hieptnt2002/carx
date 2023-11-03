import 'package:dio/dio.dart';

class DioClient {
  static final DioClient _client = DioClient._internal();
  late Dio dio;
  DioClient._internal() {
    try {
      dio = Dio(BaseOptions(
        receiveTimeout: const Duration(seconds: 30),
        connectTimeout: const Duration(seconds: 30),
        baseUrl: 'https://flexicarrent.000webhostapp.com',
        contentType: 'application/json',
        responseType: ResponseType.plain,
      ));
    } catch (e) {
      throw Exception("Dio Error load timeout");
    }
  }
  static DioClient get instance => _client;
}
