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
    dio.options.baseUrl = 'http://172.20.10.2:3000';
  }

  Future<List<ChatModel>> fetchChat() async {
    if (!await Permission.sms.request().isGranted) {
      print("Permission denied");
      throw Error();
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
      } catch (e) {
        print(e);
      }
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

  Future<List<dynamic>> analyze(List<RequestModel> messages) async {
    try {
      print('[debug] ${messages.map((element) => element.toJson()).toList()}');
      final response = await dio.post(
        '/model/messages',
        data: {
          'messages': messages.map((element) => element.toJson()).toList()
        },
      );
      print('[debug] statusCode: ${response.statusCode}');
      if (response.statusCode == 200) {
        print('Messages analyzed successfully');
        print(response.data);
        return [];
      } else {
        print('Messages not analyzed');
        return [];
      }
    } catch (e) {
      print('[debug] $e');
      return [];
    }
  }
}
