import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_voice/model/custom_widget_model.dart';
import 'package:the_voice/model/setting_model.dart';

class SearchView extends StatelessWidget {
  static String route = 'search_view';

  const SearchView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingModel>(
      builder: (context, value, child) => Scaffold(
        appBar: const CustomAppBar(
          isBack: true,
          isSurface: true,
          data: '010-0000-0000',
        ),
        body: ListView(
          children: List.generate(
            24,
            (index) => const CustomHistory(probability: 64.0, date: 'S Date'),
          ),
        ),
      ),
    );
  }
}
