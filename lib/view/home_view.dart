import 'package:flutter/material.dart';
import 'package:the_voice/model/custom_widget_model.dart';

class HomeView extends StatelessWidget {
  static String route = 'home_view';

  HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(isMain: true, selectedIndex: 1),
        bottomNavigationBar: CustomNavigationBar(selectedIndex: 1),
      ),
    );
  }
}
