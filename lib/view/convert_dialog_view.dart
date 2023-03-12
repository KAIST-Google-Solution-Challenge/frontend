import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_voice/model/setting_model.dart';
import 'package:the_voice/view/analysis_view.dart';
import 'package:the_voice/view/case_view.dart';

class ConvertCallDialogView extends StatelessWidget {
  static String route = 'convert_dialog_view';
  final Widget leading;
  final String title;
  final String subtitle;
  final String trailing;

  const ConvertCallDialogView({
    super.key,
    required this.leading,
    required this.title,
    required this.subtitle,
    required this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    TextTheme textTheme = Theme.of(context).textTheme;

    return Consumer<SettingModel>(
      builder: (context, value, child) => AlertDialog(
        icon: const Icon(Icons.sync),
        title: Text(
          value.language == Language.english ? 'Analysis?' : '분석하시겠습니까?',
        ),
        content: ListTile(
          title: Text(title),
          subtitle: Text(subtitle),
          trailing: Text(trailing),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              value.language == Language.english ? 'Cancel' : '취소',
              style: textTheme.labelLarge?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AnalysisView(number: title),
                ),
              );
            },
            child: Text(
              value.language == Language.english ? 'Analysis' : '분석',
            ),
          ),
        ],
      ),
    );
  }
}

class ConvertMessageDialogView extends StatelessWidget {
  static String route = 'convert_dialog_view';
  final int threadId;
  final Widget leading;
  final String title;
  final String subtitle;
  final String trailing;

  const ConvertMessageDialogView({
    super.key,
    required this.threadId,
    required this.leading,
    required this.title,
    required this.subtitle,
    required this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    TextTheme textTheme = Theme.of(context).textTheme;

    return Consumer<SettingModel>(
      builder: (context, value, child) => AlertDialog(
        icon: const Icon(Icons.sync),
        title: Text(
          value.language == Language.english ? 'Analysis?' : '분석하시겠습니까?',
        ),
        content: ListTile(
          title: Text(title),
          subtitle: Text(subtitle),
          trailing: Text(trailing),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              value.language == Language.english ? 'Cancel' : '취소',
              style: textTheme.labelLarge?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CaseView(
                    number: title,
                    threadId: threadId,
                  ),
                ),
              );
            },
            child: Text(
              value.language == Language.english ? 'Analysis' : '분석',
            ),
          ),
        ],
      ),
    );
  }
}
