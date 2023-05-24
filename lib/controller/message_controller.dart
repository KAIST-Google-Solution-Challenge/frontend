import 'package:dio/dio.dart';
import 'package:telephony/telephony.dart';
import 'package:the_voice/controller/contact_controller.dart';
import 'package:the_voice/util/constant.dart';

class MessageController {
  static int _loadedIndex = 0;
  static bool _isLoading = false;

  static List<SmsConversation> _smsConversations = [];

  // ignore: prefer_final_fields
  static Map<int, List<SmsMessage>> _messages = {};
  static Map<int, List<SmsMessage>> get messages {
    return _messages;
  }

  // ignore: prefer_final_fields
  static List<SmsConversation> _conversations = [];
  static List<SmsConversation> get conversations {
    if (_conversations.isEmpty) loadConversations();
    return _conversations;
  }

  static Future<void> fetchMessages() async {
    Telephony telephony = Telephony.instance;

    _smsConversations = await telephony.getConversations();

    for (SmsConversation smsConversation in _smsConversations) {
      _messages[smsConversation.threadId!] =
          (await Telephony.instance.getInboxSms(
        filter: SmsFilter.where(SmsColumn.THREAD_ID).equals(
          smsConversation.threadId.toString(),
        ),
      ))
            ..forEach((e) => e.name = ContactController.getName(e.address!))
            ..sort((a, b) => (b.date!).compareTo(a.date!));
    }

    _smsConversations = _smsConversations
        .where((element) => _messages[element.threadId]!.isNotEmpty)
        .toList();

    _smsConversations.sort(
      (a, b) => (_messages[b.threadId]![0].date!)
          .compareTo(_messages[a.threadId]![0].date!),
    );
  }

  static void loadConversations() {
    if (!_isLoading) {
      _isLoading = true;

      if (_loadedIndex + 10 < _smsConversations.length) {
        _conversations.addAll(
          _smsConversations.sublist(_loadedIndex, _loadedIndex + 10),
        );
        _loadedIndex += 10;
      } else {
        _conversations.addAll(
          _smsConversations.sublist(_loadedIndex, _smsConversations.length),
        );
        _loadedIndex = _smsConversations.length;
      }

      _isLoading = false;
    }
  }

  static Future<List<dynamic>> analyzeMessages(
    List<SmsMessage> messages,
  ) async {
    Dio dio = Dio();
    dio.options.baseUrl = BASEURL;

    try {
      final response = await dio.post(
        '/model/messages',
        data: {
          'messages': List.generate(
            messages.length,
            (i) => {'id': messages[i].id!, 'content': messages[i].body!},
          ),
        },
      );

      if (response.statusCode == 200) {
        return List.generate(
          response.data.length,
          (i) => {
            'statusCode': response.statusCode,
            'id': response.data[i]['id'],
            'probability': response.data[i]['probability'],
          },
        );
      } else {
        return [
          {'statusCode': ERROR_SERVER},
        ];
      }
    } catch (e) {
      return [
        {'statusCode': ERROR_CLIENT},
      ];
    }
  }

  static Future<dynamic> analyzeMessage(SmsMessage message) async {
    Dio dio = Dio();
    dio.options.baseUrl = BASEURL;

    try {
      final response = await dio.post(
        '/model/messages',
        data: {
          'messages': [
            {'id': message.id, 'content': message.body}
          ],
        },
      );

      if (response.statusCode == 200) {
        return {
          'statusCode': response.statusCode,
          'id': response.data[0]['id'],
          'probability': response.data[0]['probability']
        };
      } else {
        return {'statusCode': ERROR_SERVER};
      }
    } catch (e) {
      return {'statusCode': ERROR_CLIENT};
    }
  }
}
