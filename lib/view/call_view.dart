import 'package:flutter/material.dart';
import 'package:the_voice/model/custom_widget_model.dart';

class CallView extends StatelessWidget {
  static String route = 'call_view';

  CallView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(selectedIndex: 0),
      body: ListView(
        children: <Widget>[
              SizedBox(height: 16),
              CustomSearch(hintText: 'Search in calls'),
              SizedBox(height: 16),
            ] +
            List.generate(
              12,
              (index) => CustomListTile(isDate: true, isName: true),
            ),
      ),
      bottomNavigationBar: CustomNavigationBar(selectedIndex: 0),
    );
  }
}
