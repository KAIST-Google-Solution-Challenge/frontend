import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_voice/model/custom_widget_model.dart';
import 'package:the_voice/model/setting_model.dart';
import 'package:the_voice/view/message_analysis_view.dart';

class MessageChatView extends StatelessWidget {
  static String route = 'message_chat_view';

  MessageChatView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingModel>(
      builder: (context, value, child) => Scaffold(
        appBar: CustomAppBar(
          isBack: true,
          isSurface: true,
          data: '010-0000-0000',
        ),
        backgroundColor: value.brightness == Brightness.light
            ? Color(0xFFF4F4F4)
            : Color(0xFF030303),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => Navigator.pushNamed(
            context,
            MessageAnalysisView.route,
          ),
          icon: Icon(Icons.analytics),
          label: Text('Analyze'),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ListView(
                children: List<Widget>.generate(
                      12,
                      (index) => index % 2 == 0
                          ? CustomChat(isLeft: true, data: 'Text')
                          : CustomChat(isLeft: false, data: 'Text'),
                    ) +
                    <Widget>[
                      SizedBox(height: 16),
                    ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
