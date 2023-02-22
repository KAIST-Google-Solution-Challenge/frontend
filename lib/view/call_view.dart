import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_voice/model/custom_widget_model.dart';
import 'package:the_voice/model/setting_model.dart';

class CallView extends StatelessWidget {
  static String route = 'call_view';

  CallView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingModel>(
      builder: (context, value, child) => Scaffold(
        appBar: CustomAppBar(
          isBack: false,
          isSurface: true,
          data: value.language == Language.english ? 'Call' : '전화',
        ),
        body: ListView(
          children: List<Widget>.generate(
            12,
            (index) => CustomListTile(
              isCall: true,
              isDate: true,
              isName: true,
            ),
          ),
        ),
        bottomNavigationBar: CustomNavigationBar(selectedIndex: 0),
      ),
    );
  }
}
