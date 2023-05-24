import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:telephony/telephony.dart';
import 'package:the_voice/controller/message_controller.dart';
import 'package:the_voice/provider/setting_provider.dart';
import 'package:the_voice/view/message_analysis_dialog_view.dart';

class MessageView extends StatefulWidget {
  const MessageView({super.key});

  @override
  State<MessageView> createState() => _MessageViewState();
}

class _MessageViewState extends State<MessageView> {
  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (scrollNotification) {
        if (scrollNotification.metrics.pixels ==
            scrollNotification.metrics.maxScrollExtent) {
          setState(() {
            MessageController.loadConversations();
          });
        }

        return true;
      },
      child: ListView(
        children: List<Widget>.generate(
          MessageController.conversations.length,
          (index) {
            return BuildListTile(
              threadId: MessageController.conversations[index].threadId!,
            );
          },
        ),
      ),
    );
  }
}

class BuildListTile extends StatelessWidget {
  final int threadId;

  const BuildListTile({
    super.key,
    required this.threadId,
  });

  @override
  Widget build(BuildContext context) {
    TextTheme tt = Theme.of(context).textTheme;
    SettingProvider sm = context.watch<SettingProvider>();
    bool largeFont = sm.largeFont;

    SmsMessage lastMessage = MessageController.messages[threadId]![0];

    String title =
        lastMessage.name! != '' ? lastMessage.name! : lastMessage.address!;
    String subtitle = lastMessage.body!.length > 8
        ? '${lastMessage.body!.substring(0, 8)}...'
        : lastMessage.body!;
    String trailing = DateTime.fromMillisecondsSinceEpoch(lastMessage.date!)
        .toIso8601String()
        .substring(0, 10);

    void onTap() {
      showDialog(
        context: context,
        builder: (context) => MessageAnalysisDialogView(threadId: threadId),
      );
    }

    return ListTile(
      leading: const CircleAvatar(radius: 32),
      title: largeFont ? Text(title, style: tt.titleLarge) : Text(title),
      subtitle:
          largeFont ? Text(subtitle, style: tt.bodyLarge) : Text(subtitle),
      trailing:
          largeFont ? Text(trailing, style: tt.labelLarge) : Text(trailing),
      onTap: onTap,
    );
  }
}
