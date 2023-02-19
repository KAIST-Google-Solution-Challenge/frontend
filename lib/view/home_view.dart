import 'package:flutter/material.dart';
import 'package:the_voice/model/custom_widget_model.dart';

class HomeView extends StatelessWidget {
  static String route = 'home_view';

  HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(isBack: false, data: 'The Voice'),
      bottomNavigationBar: CustomNavigationBar(selectedIndex: 1),
    );
  }
}
