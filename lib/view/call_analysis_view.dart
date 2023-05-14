import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_voice/controller/call_controller.dart';
import 'package:the_voice/model/chart_model.dart';
import 'package:the_voice/model/build_model.dart';
import 'package:the_voice/model/setting_model.dart';
import 'package:the_voice/view/report_dialog_view.dart';

class CallAnalysisView extends StatefulWidget {
  final String number;
  final String datetime;

  const CallAnalysisView({
    super.key,
    required this.number,
    required this.datetime,
  });

  @override
  State<CallAnalysisView> createState() => _CallAnalysisViewState();
}

class _CallAnalysisViewState extends State<CallAnalysisView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme cs = Theme.of(context).colorScheme;
    TextTheme tt = Theme.of(context).textTheme;

    return Consumer<SettingModel>(
      builder: (_, value, __) => Scaffold(
        backgroundColor: ElevationOverlay.applySurfaceTint(
          cs.background,
          cs.surfaceTint,
          1,
        ),
        appBar: BuildAppBar(pushed: true, colored: true, title: widget.number),
        floatingActionButton: FloatingActionButton.large(
          onPressed: () => showDialog(
            context: context,
            builder: (context) => const ReportDialogView(),
          ),
          child: const Icon(Icons.report_outlined),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        body: _buildBody(value, cs, tt),
      ),
    );
  }

  Widget _buildBody(
      SettingModel settingModel, ColorScheme colorScheme, TextTheme textTheme) {
    return Center(
      child: FutureBuilder(
        future: CallController.analyze(widget.number, widget.datetime),
        builder: (_, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data! >= 0.0) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.gpp_bad, size: 32),
                  const SizedBox(height: 16),
                  Text(
                      settingModel.language == Language.english
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
                    style: textTheme.displayLarge
                        ?.copyWith(color: colorScheme.onSurface),
                  )
                ],
              );
            }
          } else {
            return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
