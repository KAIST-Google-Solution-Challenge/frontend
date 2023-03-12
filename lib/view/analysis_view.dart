import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:the_voice/controller/call_controller.dart';
import 'package:the_voice/model/chart_model.dart';
import 'package:the_voice/model/custom_widget_model.dart';
import 'package:the_voice/model/setting_model.dart';
import 'package:the_voice/view/report_dialog_view.dart';

class AnalysisView extends StatefulWidget {
  final String number;

  const AnalysisView({super.key, required this.number});

  @override
  State<AnalysisView> createState() => _AnalysisViewState();
}

class _AnalysisViewState extends State<AnalysisView> {
  CallController callController = CallController();

  @override
  void initState() {
    super.initState();
    callController.init();
  }

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
        appBar: CustomAppBar(
          isBack: true,
          isSurface: false,
          data: widget.number,
        ),
        floatingActionButton: FloatingActionButton.large(
          onPressed: () => showDialog(
            context: context,
            builder: (context) => const ReportDialogView(),
          ),
          child: const Icon(Icons.report_outlined),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        body: Center(
          child: FutureBuilder(
            future: callController.analyze('sample.m4a'),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Column(
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
                    DoughnutChart(
                      isChat: false,
                      radius: 128,
                      probability: snapshot.data!,
                    ),
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
                );
              } else {
                return LoadingAnimationWidget.staggeredDotsWave(
                  color: colorScheme.primary,
                  size: 32,
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
