import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_voice/controller/message_controller.dart';
import 'package:the_voice/model/setting_model.dart';
import 'package:the_voice/view/message_analysis_dialog_view.dart';

class MessageView extends StatefulWidget {
  const MessageView({super.key});

  @override
  State<MessageView> createState() => _MessageViewState();
}

class _MessageViewState extends State<MessageView> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: MessageController.fetchChat(),
      builder: (_, snapshot) {
        if (snapshot.hasData) {
          return ListView(
            children: List<Widget>.generate(snapshot.data!.length, (index) {
              String lastMessage = snapshot.data![index].lastMessage!;

              return BuildListTile(
                threadId: snapshot.data![index].threadId!,
                leading: const CircleAvatar(radius: 32),
                title: snapshot.data![index].address!,
                subtitle: lastMessage.length > 8
                    ? '${lastMessage.substring(0, 8)}...'
                    : lastMessage,
                trailing: DateTime.fromMillisecondsSinceEpoch(
                  snapshot.data![index].lastMessageDate!,
                ).toIso8601String().substring(0, 10),
              );
            }),
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}

class BuildListTile extends StatelessWidget {
  final int threadId;
  final Widget leading;
  final String title;
  final String subtitle;
  final String trailing;

  const BuildListTile({
    super.key,
    required this.threadId,
    required this.leading,
    required this.title,
    required this.subtitle,
    required this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    TextTheme tt = Theme.of(context).textTheme;
    SettingModel sm = context.watch<SettingModel>();
    bool largeFont = sm.largeFont;

    void onTap() {
      showDialog(
        context: context,
        builder: (context) => MessageAnalysisDialogView(
          threadId: threadId,
          leading: leading,
          title: title,
          subtitle: subtitle,
          trailing: trailing,
        ),
      );
    }

    return ListTile(
      leading: leading,
      title: largeFont ? Text(title, style: tt.titleLarge) : Text(title),
      subtitle:
          largeFont ? Text(subtitle, style: tt.bodyLarge) : Text(subtitle),
      trailing:
          largeFont ? Text(trailing, style: tt.labelLarge) : Text(trailing),
      onTap: onTap,
    );
  }
}
