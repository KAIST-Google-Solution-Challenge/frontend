import 'package:flutter/material.dart';
import 'package:the_voice/controller/message_controller.dart';
import 'package:the_voice/model/build_model.dart';

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

              return CustomMessageListTile(
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
