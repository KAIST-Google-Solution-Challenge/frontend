import 'package:dio/dio.dart' as d;
import 'package:permission_handler/permission_handler.dart';
import 'package:telephony/telephony.dart';
import 'package:the_voice/model/chat_model.dart';

class MessageController {
  late d.Dio dio;

  final telephony = Telephony.instance;

  void init() {
    dio = d.Dio();
    // dio.options.baseUrl = 'http://10.0.2.2:3000';
    // dio.options.baseUrl = 'http://localhost:3000';
    dio.options.baseUrl = 'https://f0de-110-76-108-201.jp.ngrok.io';
  }

  Future<List<ChatModel>> fetchChat() async {
    var smsStatus = await Permission.sms.status;
    if (!smsStatus.isGranted) {
      await Permission.sms.request();
    }

    List<ChatModel> results = [];
    List<SmsConversation> chats = await telephony.getConversations();

    for (var chat in chats) {
      try {
        List<SmsMessage> messages = await telephony.getInboxSms(
          filter: SmsFilter.where(SmsColumn.THREAD_ID).equals(
            chat.threadId.toString(),
          ),
        );
        ChatModel chatModel = ChatModel(
            threadId: chat.threadId,
            address: messages[0].address,
            lastMessage: messages[0].body,
            lastMessageDate: messages[0].date);
        results.add(chatModel);
        // ignore: empty_catches
      } catch (e) {}
    }

    results.sort((a, b) => b.lastMessageDate!.compareTo(a.lastMessageDate!));
    return results;
  }

  Future<List<MessageModel>> fetchMessages(int threadId) async {
    List<SmsMessage> receivedMessages = await telephony.getInboxSms(
      filter: SmsFilter.where(SmsColumn.THREAD_ID).equals(
        threadId.toString(),
      ),
    );
    List<SmsMessage> sentMessages = await telephony.getSentSms(
      filter: SmsFilter.where(SmsColumn.THREAD_ID).equals(
        threadId.toString(),
      ),
    );

    List<MessageModel> receivedMessageModel = List.generate(
      receivedMessages.length,
      (index) => MessageModel(
        smsMessage: receivedMessages[index],
        sender: Sender.opponent,
      ),
    );
    List<MessageModel> sentMessageModel = List.generate(
      sentMessages.length,
      (index) => MessageModel(
        smsMessage: sentMessages[index],
        sender: Sender.user,
      ),
    );

    List<MessageModel> messages = receivedMessageModel + sentMessageModel;
    messages.sort((a, b) => a.smsMessage.date!.compareTo(b.smsMessage.date!));
    return messages;
  }

  Future<List<dynamic>> analyze(List<dynamic> messages) async {
    try {
      final response = await dio.post(
        '/model/messages',
        data: {
          'messages': messages,
        },
      );

      if (response.statusCode == 200) {
        for (int i = 0; i < response.data.length; i++) {
          response.data[i]['probability'] = double.parse(
            response.data[i]['probability'].toString().substring(0, 4),
          );
        }

        return response.data;
      } else {
        return List.generate(
          messages.length,
          (index) => {
            'id': messages[index]['id'],
            'probability': 0.0,
          },
        );
      }
    } catch (e) {
      return List.generate(
        messages.length,
        (index) => {
          'id': messages[index]['id'],
          'probability': 0.0,
        },
      );
    }
  }
}
