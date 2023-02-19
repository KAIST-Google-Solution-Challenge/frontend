import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_voice/model/custom_widget_model.dart';
import 'package:the_voice/model/setting_model.dart';

// Todo: Add Filter Chip
class ChatAnalysisView extends StatelessWidget {
  static String route = 'chat_analysis_view';

  ChatAnalysisView({super.key});

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
          icon: Icon(Icons.report),
          label: Text('Report'),
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
                          ? CustomChatAnalysis(
                              isLeft: true,
                              data: 'Text',
                              probability: 64,
                            )
                          : CustomChatAnalysis(
                              isLeft: false,
                              data: 'Text',
                              probability: 16,
                            ),
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
