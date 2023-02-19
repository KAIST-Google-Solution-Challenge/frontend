import 'package:flutter/material.dart';
import 'package:the_voice/model/custom_widget_model.dart';

class MessageView extends StatelessWidget {
  static String route = 'message_view';

  MessageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(isBack: false, data: 'Messages'),
      body: ListView(
        children: <Widget>[
              SizedBox(height: 16),
              CustomSearch(hintText: 'Search in messages'),
              SizedBox(height: 16),
            ] +
            List<Widget>.generate(
              12,
              (index) => CustomListTile(isDate: false, isName: true),
            ),
      ),
      bottomNavigationBar: CustomNavigationBar(selectedIndex: 2),
    );
  }
}
