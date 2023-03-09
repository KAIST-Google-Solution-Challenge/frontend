import 'package:dio/dio.dart' as d;
import 'package:permission_handler/permission_handler.dart';
import 'package:telephony/telephony.dart';
import 'package:the_voice/model/chat_model.dart';

class MessageController {
  late d.Dio dio;

  final telephony = Telephony.instance;

  void init() {
    dio = d.Dio();
    dio.options.baseUrl = 'http://10.0.2.2:3000';
    // dio.options.baseUrl = 'http://localhost:3000';
  }

  Future<List<ChatModel>> fetchChat() async {
    if (!await Permission.sms.request().isGranted) {
      print("Permission denied");
      throw Error();
    }

    List<ChatModel> results = [];
    List<SmsConversation> chats = await telephony.getConversations();

    for (var chat in chats) {
      List<SmsMessage> messages = await telephony.getInboxSms(
          filter: SmsFilter.where(SmsColumn.THREAD_ID)
              .equals(chat.threadId.toString()));
      ChatModel chatModel = ChatModel(
          threadId: chat.threadId,
          address: messages[0].address,
          lastMessage: messages[0].body,
          lastMessageDate: messages[0].date);
      results.add(chatModel);
    }
    return results;
  }

  Future<void> analyze(List<String> messages) async {
    try {
      final response = await dio.post('/model/messages/', data: {
        messages: messages,
      });
      if (response.statusCode == 200) {
        print('Messages analyzed successfully');
      } else {
        print('Messages not analyzed');
      }
    } catch (e) {}
  }
}
