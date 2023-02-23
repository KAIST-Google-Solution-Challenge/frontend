import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_voice/model/chart_model.dart';
import 'package:the_voice/model/custom_widget_model.dart';
import 'package:the_voice/model/setting_model.dart';
import 'package:the_voice/view/case_view.dart';

class AnalysisView extends StatelessWidget {
  static String route = 'analysis_view';

  const AnalysisView({super.key});

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    TextTheme textTheme = Theme.of(context).textTheme;

    return Consumer<SettingModel>(
      builder: (context, value, child) => Scaffold(
        backgroundColor: ElevationOverlay.applySurfaceTint(
          colorScheme.background,
          colorScheme.surfaceTint,
          1,
        ),
        appBar: const CustomAppBar(
          isBack: true,
          isSurface: false,
          data: '010-0000-0000',
        ),
        floatingActionButton: FloatingActionButton.large(
          onPressed: () => Navigator.pushNamed(context, CaseView.route),
          child: const Icon(Icons.manage_search),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.gpp_bad, size: 32),
              const SizedBox(height: 16),
              Text(
                  value.language == Language.english
                      ? 'Phishing Probability'
                      : '보이스피싱 확률',
                  style: textTheme.headlineSmall),
              const SizedBox(height: 64),
              const DoughnutChart(isChat: false, radius: 128, probability: 64),
              const SizedBox(height: 64),
              Text(
                value.language == Language.english
                    ? '35 Other Phishing Cases'
                    : '35개의 보이스피싱 사례가',
                style: textTheme.bodyLarge?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              Text(
                value.language == Language.english
                    ? 'Detected With This Number!'
                    : '이 번호로 탐지되었습니다!',
                style: textTheme.bodyLarge?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
