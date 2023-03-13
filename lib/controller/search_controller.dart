import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';

class SearchController {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  late Dio dio;

  void init() {
    dio = Dio();
    // dio.options.baseUrl = 'http://10.0.2.2:3000';
    // dio.options.baseUrl = 'http://localhost:3000';
    dio.options.baseUrl = 'https://9d1e-110-76-108-201.jp.ngrok.io';
  }

  Future<List<dynamic>> search(String number) async {
    try {
      List<dynamic> documents = [];

      await firebaseFirestore.collection('phishing_probability').get().then(
        (value) {
          for (dynamic document in value.docs) {
            if (document['number'] == number) {
              documents.add(document);
            }
          }
        },
      );

      return documents;
    } catch (e) {
      return List.generate(
        16,
        (index) => {
          "number": number,
          "probability": 0.0,
          "timestamp":
              Timestamp.now().toDate().toIso8601String().substring(0, 10),
        },
      );
    }
  }
}
