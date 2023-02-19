import 'package:flutter/material.dart';
import 'package:the_voice/model/chart_model.dart';
import 'package:the_voice/model/custom_widget_model.dart';
import 'package:the_voice/view/chat_analysis_view.dart';
import 'package:the_voice/view/report_dialog_view.dart';

class CallAnalysisView extends StatelessWidget {
  static String route = 'call_analysis_view';

  CallAnalysisView({super.key});

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    TextTheme textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: ElevationOverlay.applySurfaceTint(
        colorScheme.background,
        colorScheme.surfaceTint,
        1,
      ),
      appBar: CustomAppBar(
        isBack: true,
        isSurface: false,
        data: '010-0000-0000',
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.analytics),
          SizedBox(height: 16),
          Text('Vishing Probability', style: textTheme.headlineSmall),
          SizedBox(height: 16),
          Text(
            'Text',
            style: textTheme.bodyLarge?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 64),
          DoughnutChart(radius: 128, probability: 64),
          SizedBox(height: 64),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              OutlinedButton.icon(
                onPressed: () => Navigator.pushNamed(
                  context,
                  ChatAnalysisView.route,
                ),
                icon: Icon(Icons.add),
                label: Text('Show Details'),
              ),
              SizedBox(width: 16),
              FilledButton.icon(
                onPressed: () => showDialog(
                  context: context,
                  builder: (context) => ReportDialogView(),
                ),
                icon: Icon(Icons.report),
                label: Text('Report'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
