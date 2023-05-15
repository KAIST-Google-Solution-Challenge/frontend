import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_voice/model/setting_model.dart';
import 'package:the_voice/view/call_analysis_view.dart';

class CallAnalysisDialogView extends StatelessWidget {
  final Widget leading;
  final String title;
  final String subtitle;
  final String trailing;
  final String datetime;

  const CallAnalysisDialogView({
    super.key,
    required this.leading,
    required this.title,
    required this.subtitle,
    required this.trailing,
    required this.datetime,
  });

  @override
  Widget build(BuildContext context) {
    ColorScheme cs = Theme.of(context).colorScheme;
    TextTheme tt = Theme.of(context).textTheme;

    return Consumer<SettingModel>(
      builder: (_, value, __) {
        final bool lang = value.language == Language.english;

        return AlertDialog(
          icon: const Icon(Icons.assessment),
          title: Text(lang ? 'Analysis?' : '분석하시겠습니까?'),
          content: ListTile(
            title: Text(title),
            subtitle: Text(subtitle),
            trailing: Text(trailing),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                lang ? 'Cancel' : '취소',
                style: tt.labelLarge?.copyWith(
                  color: cs.onSurfaceVariant,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(context, _buildRoute(title, datetime));
              },
              child: Text(lang ? 'Analysis' : '분석'),
            ),
          ],
        );
      },
    );
  }

  Route _buildRoute(String title, String datetime) {
    return MaterialPageRoute(
      builder: (context) => CallAnalysisView(
        number: title,
        datetime: datetime,
      ),
    );
  }
}
