import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:the_voice/controller/message_controller.dart';
import 'package:the_voice/model/custom_widget_model.dart';
import 'package:the_voice/model/setting_model.dart';

class MessageView extends StatefulWidget {
  static String route = 'message_view';

  const MessageView({super.key});

  @override
  State<MessageView> createState() => _MessageViewState();
}

class _MessageViewState extends State<MessageView> {
  final MessageController messageController = MessageController();

  @override
  void initState() {
    super.initState();
    messageController.init();
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Consumer<SettingModel>(
      builder: (context, value, child) => Scaffold(
        appBar: CustomAppBar(
          isBack: false,
          isSurface: true,
          data: value.language == Language.english ? 'Message' : '메시지',
        ),
        body: FutureBuilder(
          future: messageController.fetchChat(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView(
                children: List<Widget>.generate(snapshot.data!.length, (index) {
                  String lastMessage = snapshot.data![index].lastMessage!;

                  return CustomMessageListTile(
                    threadId: snapshot.data![index].threadId!,
                    leading: const CircleAvatar(radius: 32),
                    title: snapshot.data![index].address!,
                    subtitle: lastMessage.length > 12
                        ? '${lastMessage.substring(0, 12)}...'
                        : lastMessage,
                    trailing: DateTime.fromMillisecondsSinceEpoch(
                      snapshot.data![index].lastMessageDate!,
                    ).toIso8601String().substring(0, 10),
                  );
                }),
              );
            } else {
              return Center(
                child: LoadingAnimationWidget.staggeredDotsWave(
                  color: colorScheme.primary,
                  size: 32,
                ),
              );
            }
          },
        ),
        bottomNavigationBar: const CustomNavigationBar(selectedIndex: 2),
      ),
    );
  }
}
