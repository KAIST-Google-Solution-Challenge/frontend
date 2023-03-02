import 'package:dio/dio.dart';
import 'package:get/get.dart';

class SearchController extends GetxController {
  late Dio dio;

  @override
  void onInit() {
    super.onInit();
    dio = Dio();
    dio.options.baseUrl = 'http://10.0.2.2:3000';
    // dio.options.baseUrl = 'http://localhost:3000';
  }

  Future<List<dynamic>> search(String number) async {
    try {
      final response = await dio.get('/records/$number');
      if (response.statusCode == 200) {
        print(response.data);
        return response.data;
      }
      return [];
    } catch (error) {
      print(error);
      return [];
    }
  }
}
