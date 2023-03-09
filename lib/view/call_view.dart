import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:the_voice/controller/call_controller.dart';
import 'package:the_voice/controller/search_controller.dart';
import 'package:the_voice/model/custom_widget_model.dart';
import 'package:the_voice/model/setting_model.dart';

class CallView extends StatelessWidget {
  static String route = 'call_view';

  CallView({super.key});

  final CallController _callController = Get.put(CallController());
  final SearchController _searchController = Get.put(SearchController());

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
            (index) => const CustomListTile(
              isCall: true,
              isDate: true,
              isName: true,
              date: 'C Date',
              name: 'C Name',
              number: 'C 010-0000-0000',
              time: 'C Time',
            ),
          ),
        ),
        bottomNavigationBar: const CustomNavigationBar(selectedIndex: 0),
      ),
    );
  }
}
