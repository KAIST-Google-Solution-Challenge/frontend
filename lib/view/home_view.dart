import 'package:flutter/material.dart';
import 'package:the_voice/model/build_model.dart';
import 'package:the_voice/model/setting_model.dart';

class HomeView extends StatelessWidget {
  final SettingModel sm;
  const HomeView({super.key, required this.sm});

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    TextTheme textTheme = Theme.of(context).textTheme;

    return Column(
      children: [
        const Expanded(flex: 1, child: SizedBox()),
        Text(
          sm.language == Language.english ? 'The Voice' : '그놈 목소리',
          style: textTheme.headlineLarge?.copyWith(
            color: colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 32),
        BuildSearch(sm: sm),
        const Expanded(flex: 4, child: SizedBox()),
      ],
    );
  }
}
