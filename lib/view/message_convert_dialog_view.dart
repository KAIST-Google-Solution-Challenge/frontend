import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_voice/model/setting_model.dart';
import 'package:the_voice/view/message_analysis_view.dart';

class MessageConvertDialogView extends StatelessWidget {
  final int threadId;
  final Widget leading;
  final String title;
  final String subtitle;
  final String trailing;

  const MessageConvertDialogView({
    super.key,
    required this.threadId,
    required this.leading,
    required this.title,
    required this.subtitle,
    required this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    ColorScheme cs = Theme.of(context).colorScheme;
    TextTheme tt = Theme.of(context).textTheme;

    return Consumer<SettingModel>(
      builder: (_, value, __) {
        final bool lang = value.language == Language.english;

        return AlertDialog(
          icon: const Icon(Icons.sync),
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
                Navigator.push(context, _buildRoute(title, threadId));
              },
              child: Text(lang ? 'Analysis' : '분석'),
            ),
          ],
        );
      },
    );
  }

  Route _buildRoute(String title, int threadId) {
    return MaterialPageRoute(
      builder: (context) => MessageAnalysisView(
        number: title,
        threadId: threadId,
      ),
    );
  }
}
