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
    SettingModel sm = context.watch<SettingModel>();
    bool largeFont = sm.largeFont;
    bool lang = sm.language == Language.english;

    return AlertDialog(
      icon: const Icon(Icons.assessment),
      title: largeFont
          ? Text(lang ? 'Analysis?' : '분석하시겠습니까?', style: tt.headlineLarge)
          : Text(lang ? 'Analysis?' : '분석하시겠습니까?'),
      content: ListTile(
        title: largeFont ? Text(title, style: tt.titleLarge) : Text(title),
        subtitle:
            largeFont ? Text(subtitle, style: tt.bodyLarge) : Text(subtitle),
        trailing:
            largeFont ? Text(trailing, style: tt.labelLarge) : Text(trailing),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            lang ? 'Cancel' : '취소',
            style: largeFont
                ? tt.titleLarge?.copyWith(color: cs.onSurfaceVariant)
                : tt.labelLarge?.copyWith(color: cs.onSurfaceVariant),
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            Navigator.push(context, _buildRoute(title, datetime));
          },
          child: largeFont
              ? Text(lang ? 'Analysis' : '분석', style: tt.titleLarge)
              : Text(lang ? 'Analysis' : '분석'),
        ),
      ],
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
