import 'package:contacts_service/contacts_service.dart';
import 'package:dio/dio.dart' as d;
import 'package:permission_handler/permission_handler.dart';
import 'package:telephony/telephony.dart';
import 'package:the_voice/controller/contact_controller.dart';
import 'package:the_voice/model/chat_model.dart';
import 'package:the_voice/util/constant.dart';

class MessageController {
  static Future<List<ChatModel>> fetchChat() async {
    final telephony = Telephony.instance;

    var contactsStatus = await Permission.contacts.status;
    if (!contactsStatus.isGranted) {
      await Permission.contacts.request();
    }

    var smsStatus = await Permission.sms.status;
    if (!smsStatus.isGranted) {
      await Permission.sms.request();
    }

    if (!contactsStatus.isGranted || !smsStatus.isGranted) {
      return [];
    }

    List<ChatModel> results = [];

    // Get All Conversations from device
    List<SmsConversation> chats = await telephony.getConversations();

    final contacts = await ContactsService.getContacts(withThumbnails: false);
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
          address: ContactController.getName(contacts, messages[0].address!),
          lastMessage: messages[0].body,
          lastMessageDate: messages[0].date,
        );
        results.add(chatModel);
      }
    }

    results.sort((a, b) => b.lastMessageDate!.compareTo(a.lastMessageDate!));

    print("(fetchChat) $results");
    return results.length > 60 ? results.sublist(0, 60) : results;
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
    if (messages.length > 10) {
      messages = messages.sublist(messages.length - 10);
    }
    return messages;
  }

  static Future<List<dynamic>> analyze(List<dynamic> messages) async {
    try {
      final dio = d.Dio();
      dio.options.baseUrl = BASEURL;

      final response = await dio.post(
        '/model/messages',
        data: {
          'messages': messages,
        },
      );

      List<dynamic> results = [];
      if (response.statusCode == 200) {
        for (int i = 0; i < response.data.length; i++) {
          if (response.data[i]['probability'] == null) {
            continue;
          }
          results.add(
            {
              'id': response.data[i]['id'],
              'probability': double.parse(
                  response.data[i]['probability'].toString().substring(0, 4)),
            },
          );
        }

        return results;
      }
      return List.generate(
        messages.length,
        (index) => {
          'id': messages[index]['id'],
          'probability': -response.statusCode!.toDouble(),
        },
      );
    } catch (e) {
      print(e);
      return [];
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
