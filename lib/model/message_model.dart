import 'package:the_voice/model/datum_model.dart';

class MessageModel {
  final DateTime datetime; // datetime of the final message
  final String name; // 'Mother' if contact exists, else empty string
  final String number; // '010-2236-5450'
  final List<Datum> data; // text data of the messages

  MessageModel({
    required this.datetime,
    required this.name,
    required this.number,
    required this.data,
  });
}
