import 'package:telephony/telephony.dart';

class ChatModel {
  final int? threadId;
  final String? address;
  final String? lastMessage;
  final int? lastMessageDate;

  ChatModel({
    required this.threadId,
    required this.address,
    required this.lastMessage,
    required this.lastMessageDate,
  });
}

enum Sender {
  user,
  opponent,
}

class MessageModel {
  final SmsMessage smsMessage;
  final Sender sender;

  MessageModel({required this.smsMessage, required this.sender});
}

class RequestModel {
  final int id;
  final String content;

  RequestModel({required this.id, required this.content});
}
