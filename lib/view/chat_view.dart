import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_voice/model/custom_widget_model.dart';
import 'package:the_voice/model/setting_model.dart';

class ChatView extends StatelessWidget {
  static String route = 'chat_view';

  ChatView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingModel>(
      builder: (context, value, child) => Scaffold(
        appBar: CustomAppBar(isBack: true, data: '010-0000-0000'),
        backgroundColor: value.brightness == Brightness.light
            ? Color(0xFFF4F4F4)
            : Color(0xFF030303),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {},
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
