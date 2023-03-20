import 'package:dio/dio.dart' as d;
import 'package:permission_handler/permission_handler.dart';
import 'package:telephony/telephony.dart';
import 'package:the_voice/model/chat_model.dart';
import 'package:the_voice/util/constant.dart';

class MessageController {
  static Future<List<ChatModel>> fetchChat() async {
    final telephony = Telephony.instance;

    var smsStatus = await Permission.sms.status;
    if (!smsStatus.isGranted) {
      await Permission.sms.request();
    }

    List<ChatModel> results = [];
    if (smsStatus.isGranted) {
      // Get All Conversations from device
      List<SmsConversation> chats = await telephony.getConversations();

      for (var chat in chats) {
        // Get inbox messages according to conversation id
        List<SmsMessage> messages = await telephony.getInboxSms(
          filter: SmsFilter.where(SmsColumn.THREAD_ID).equals(
            chat.threadId.toString(),
          ),
        );

        if (messages.isNotEmpty) {
          ChatModel chatModel = ChatModel(
              threadId: chat.threadId,
              address: messages[0].address ?? 'undefined',
              lastMessage: messages[0].body ?? 'undefined',
              lastMessageDate: messages[0].date ?? 0);
          results.add(chatModel);
        }
      }
    }
    if (results.isEmpty) {
      return results;
    }
    results.sort((a, b) => b.lastMessageDate!.compareTo(a.lastMessageDate!));

    print("(fetchChat) $results");
    return results;
  }

  static Future<List<MessageModel>> fetchMessages(int threadId) async {
    final telephony = Telephony.instance;

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

  static Future<List<dynamic>> analyze(List<dynamic> messages) async {
    try {
      final dio = d.Dio();
      dio.options.baseUrl = BASEURL;
      final response = await dio.post(
        '/model/messages',
        data: {
          'messages': messages.sublist(messages.length - 10),
        },
      );

      List<double> results = [];
      if (response.statusCode == 200) {
        for (int i = 0; i < response.data.length; i++) {
          if (response.data[i]['probability'] == null) {
            continue;
          }
          results.add(double.parse(
            response.data[i]['probability'].toString().substring(0, 4),
          ));
        }

        return response.data;
      } else {
        return List.generate(
          messages.length,
          (index) => {
            'id': messages[index]['id'],
            'probability': -response.statusCode!.toDouble(),
          },
        );
      }
    } catch (e) {
      return List.generate(
        messages.length,
        (index) => {
          'id': messages[index]['id'],
          'probability': -2.0,
        },
      );
    }
  }

  static Future<dynamic> analyzeSingle(String message) async {
    try {
      final dio = d.Dio();
      dio.options.baseUrl = BASEURL;

      final response = await dio.post(
        '/model/messages',
        data: {
          'messages': [
            {'id': 1, 'content': message}
          ],
        },
      );

      if (response.statusCode == 200) {
        print(response.data);
        return response.data[0]['probability'];
      } else {
        return -1;
      }
    } catch (e) {
      print(e);
      return -1;
    }
  }
}
