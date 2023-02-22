import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_voice/model/custom_widget_model.dart';
import 'package:the_voice/model/setting_model.dart';

class HomeView extends StatelessWidget {
  static String route = 'home_view';

  HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    TextTheme textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: CustomAppBar(
        isBack: false,
        isSurface: true,
        data: '',
      ),
      body: Consumer<SettingModel>(
        builder: (context, value, child) => Column(
          children: [
            Expanded(flex: 1, child: SizedBox()),
            Text(value.language == Language.english ? 'The Voice' : '그놈 목소리',
                style: textTheme.headlineLarge?.copyWith(
                  color: colorScheme.onSurface,
                )),
            SizedBox(height: 32),
            CustomSearch(
              hintText: value.language == Language.english
                  ? 'Search phone number'
                  : '전화번호 검색',
            ),
            Expanded(flex: 4, child: SizedBox()),
          ],
        ),
      ),
      bottomNavigationBar: CustomNavigationBar(selectedIndex: 1),
    );
  }
}
