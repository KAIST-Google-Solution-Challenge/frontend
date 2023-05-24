import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:telephony/telephony.dart';
import 'package:the_voice/controller/message_controller.dart';
import 'package:the_voice/provider/setting_provider.dart';
import 'package:the_voice/view/message_analysis_view.dart';

class MessageAnalysisDialogView extends StatelessWidget {
  final int threadId;

  const MessageAnalysisDialogView({super.key, required this.threadId});

  @override
  Widget build(BuildContext context) {
    ColorScheme cs = Theme.of(context).colorScheme;
    TextTheme tt = Theme.of(context).textTheme;
    SettingProvider sm = context.watch<SettingProvider>();
    bool largeFont = sm.largeFont;
    bool lang = sm.language == Language.english;

    SmsMessage lastMessage = MessageController.messages[threadId]![0];

    String title =
        lastMessage.name! != '' ? lastMessage.name! : lastMessage.address!;
    String subtitle = lastMessage.body!.length > 8
        ? '${lastMessage.body!.substring(0, 8)}...'
        : lastMessage.body!;
    String trailing = DateTime.fromMillisecondsSinceEpoch(lastMessage.date!)
        .toIso8601String()
        .substring(0, 10);

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
            Navigator.push(context, _buildRoute(threadId));
          },
          child: largeFont
              ? Text(lang ? 'Analysis' : '분석', style: tt.titleLarge)
              : Text(lang ? 'Analysis' : '분석'),
        ),
      ],
    );
  }

  Route _buildRoute(int threadId) {
    return MaterialPageRoute(
      builder: (context) => MessageAnalysisView(threadId: threadId),
    );
  }
}
