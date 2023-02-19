import 'package:flutter/material.dart';
import 'package:the_voice/model/chart_model.dart';
import 'package:the_voice/model/custom_widget_model.dart';

class MessageAnalysisView extends StatelessWidget {
  static String route = 'message_analysis_view';

  MessageAnalysisView({super.key});

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
      body: Center(
        child: Column(
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
            DoughnutChart(radius: 128, probability: 16),
            SizedBox(height: 64),
            FilledButton.icon(
              onPressed: () {},
              icon: Icon(Icons.report),
              label: Text('Report'),
            ),
          ],
        ),
      ),
    );
  }
}
