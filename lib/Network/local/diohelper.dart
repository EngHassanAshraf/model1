import 'package:dio/dio.dart';

class DioHelper {
  static Dio? animiadio;

  static init() {
    animiadio = Dio(
      BaseOptions(
        baseUrl: "http://192.168.244.37:8000",
        receiveDataWhenStatusError: true,
      ),
    );
  }

  static Future<Response> getData({
    required String path,
    Map<String, dynamic>? queryPara,
  }) async {
    return await animiadio!.get(path, queryParameters: queryPara);
  }
}
