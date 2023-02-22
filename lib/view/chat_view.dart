import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_voice/model/custom_widget_model.dart';
import 'package:the_voice/model/setting_model.dart';
import 'package:the_voice/view/analysis_view.dart';
import 'package:the_voice/view/case_view.dart';

class ChatView extends StatelessWidget {
  static String route = 'chat_view';

  ChatView({super.key});

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
        floatingActionButton: FloatingActionButton.large(
          onPressed: () => Navigator.pushNamed(
            context,
            AnalysisView.route,
          ),
          child: Icon(Icons.search),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ListView(
                children: List<Widget>.generate(
                      24,
                      (index) => index % 2 == 0
                          ? CustomChat(isLeft: true, data: 'Opponent Text')
                          : CustomChat(isLeft: false, data: 'My Text'),
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
