import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:the_voice/controller/call_controller.dart';
import 'package:the_voice/model/chart_model.dart';
import 'package:the_voice/model/build_model.dart';
import 'package:the_voice/model/setting_model.dart';
import 'package:the_voice/view/report_dialog_view.dart';

class AnalysisView extends StatefulWidget {
  final String number;
  final String datetime;

  const AnalysisView({
    super.key,
    required this.number,
    required this.datetime,
  });

  @override
  State<AnalysisView> createState() => _AnalysisViewState();
}

class _AnalysisViewState extends State<AnalysisView> {
  @override
  void initState() {
    super.initState();
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
        appBar: BuildAppBar(
          pushed: true,
          colored: true,
          title: widget.number,
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
            future: CallController.analyze(widget.number, widget.datetime),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data! >= 0.0) {
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
                        'Explainalbe AI',
                        style: textTheme.bodyLarge?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  );
                } else if (snapshot.data! == -1.0) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'ERROR',
                        style: textTheme.headlineLarge?.copyWith(
                          color: colorScheme.onSurface,
                        ),
                      ),
                      Text(
                        'NO FILE',
                        style: textTheme.displayLarge?.copyWith(
                          color: colorScheme.onSurface,
                        ),
                      )
                    ],
                  );
                } else if (snapshot.data! == -2.0) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'ERROR',
                        style: textTheme.headlineLarge?.copyWith(
                          color: colorScheme.onSurface,
                        ),
                      ),
                      Text(
                        'SERVER',
                        style: textTheme.displayLarge?.copyWith(
                          color: colorScheme.onSurface,
                        ),
                      )
                    ],
                  );
                } else {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'ERROR',
                        style: textTheme.headlineLarge?.copyWith(
                          color: colorScheme.onSurface,
                        ),
                      ),
                      Text(
                        (-snapshot.data!.toInt()).toString(),
                        style: textTheme.displayLarge?.copyWith(
                          color: colorScheme.onSurface,
                        ),
                      )
                    ],
                  );
                }
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
