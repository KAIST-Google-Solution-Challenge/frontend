import 'package:dio/dio.dart';

class SearchController {
  late Dio dio;

  void init() {
    dio = Dio();
    // dio.options.baseUrl = 'http://10.0.2.2:3000';
    // dio.options.baseUrl = 'http://localhost:3000';
    dio.options.baseUrl = 'https://9d1e-110-76-108-201.jp.ngrok.io';
  }

  Future<List<dynamic>> search(String number) async {
    try {
      // firebase
      final response = await dio.get('/records/$number');

      return response.statusCode == 200
          ? response.data
          : List.generate(
              16,
              (index) => {
                "number": number,
                "probability": 0.0,
                "timestamp": "timestamp",
              },
            );
    } catch (e) {
      return List.generate(
        16,
        (index) => {
          "number": number,
          "probability": 0.0,
          "timestamp": "timestamp",
        },
      );
    }
  }
}
