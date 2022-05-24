import 'package:dio/dio.dart';

class RemoteDioHelper {
  static Dio? ocrdio;

  static init() {
    ocrdio = Dio(
      BaseOptions(
        baseUrl: "https://api.apilayer.com/",
        receiveDataWhenStatusError: true,
      ),
    );
  }

  static Future<Response> getData({
    required String path,
    Map<String, dynamic>? queryPara,
  }) async {
    return await ocrdio!.get(path, queryParameters: queryPara);
  }
}
