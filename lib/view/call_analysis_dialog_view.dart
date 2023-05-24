import 'package:call_log/call_log.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_voice/provider/setting_provider.dart';
import 'package:the_voice/view/call_analysis_view.dart';

class CallAnalysisDialogView extends StatelessWidget {
  final CallLogEntry callLogEntry;

  const CallAnalysisDialogView({super.key, required this.callLogEntry});

  @override
  Widget build(BuildContext context) {
    ColorScheme cs = Theme.of(context).colorScheme;
    TextTheme tt = Theme.of(context).textTheme;
    SettingProvider sm = context.watch<SettingProvider>();
    bool largeFont = sm.largeFont;
    bool lang = sm.language == Language.english;

    int minute = callLogEntry.duration! ~/ 60;
    int second = callLogEntry.duration! % 60;

    String title =
        callLogEntry.name! != '' ? callLogEntry.name! : callLogEntry.number!;
    String subtitle =
        callLogEntry.callType.toString().substring(9).toLowerCase();
    String trailing =
        '${minute < 10 ? '0$minute' : minute}:${second < 10 ? '0$second' : second}';

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
            Navigator.push(context, _buildRoute(callLogEntry));
          },
          child: largeFont
              ? Text(lang ? 'Analysis' : '분석', style: tt.titleLarge)
              : Text(lang ? 'Analysis' : '분석'),
        ),
      ],
    );
  }

  Route _buildRoute(CallLogEntry callLogEntry) {
    return MaterialPageRoute(
      builder: (context) => CallAnalysisView(callLogEntry: callLogEntry),
    );
  }
}
