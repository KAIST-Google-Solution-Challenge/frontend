import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';

class SearchController {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  late Dio dio;

  Future<List<dynamic>> search(String number) async {
    try {
      List<dynamic> documents = [];

      await firebaseFirestore.collection('phishing_probability').get().then(
        (value) {
          for (dynamic document in value.docs) {
            if (document['number'] == number) {
              documents.add(
                {
                  'probability': double.parse(document['probability']),
                  'timestamp': document['timestamp'],
                },
              );
            }
          }
        },
      );

      return documents;
    } catch (e) {
      return [];
    }
  }
}
