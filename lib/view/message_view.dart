import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:the_voice/controller/message_controller.dart';
import 'package:the_voice/model/custom_widget_model.dart';
import 'package:the_voice/model/setting_model.dart';

class MessageView extends StatelessWidget {
  static String route = 'message_view';

  MessageView({super.key});

  final MessageController _messageController = Get.put(MessageController());

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingModel>(
      builder: (context, value, child) => Scaffold(
        appBar: CustomAppBar(
          isBack: false,
          isSurface: true,
          data: value.language == Language.english ? 'Message' : '메시지',
        ),
        body: ListView(
          children: List<Widget>.generate(
            12,
            (index) => const CustomListTile(
              isCall: false,
              isDate: false,
              isName: true,
              date: 'M Date',
              name: 'M Name',
              number: 'M 010-0000-0000',
              time: 'M Time',
            ),
          ),
        ),
        bottomNavigationBar: const CustomNavigationBar(selectedIndex: 2),
      ),
    );
  }
}
