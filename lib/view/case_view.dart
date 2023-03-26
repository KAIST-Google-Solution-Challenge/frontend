import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:the_voice/controller/message_controller.dart';
import 'package:the_voice/model/chat_model.dart';
import 'package:the_voice/model/custom_widget_model.dart';
import 'package:the_voice/model/setting_model.dart';
import 'package:the_voice/view/report_dialog_view.dart';

class CaseView extends StatefulWidget {
  final String number;
  final int threadId;

  const CaseView({
    super.key,
    required this.number,
    required this.threadId,
  });

  @override
  State<CaseView> createState() => _CaseViewState();
}

class _CaseViewState extends State<CaseView> {
  late List<MessageModel> messages;
  late List<dynamic> probabilities;

  @override
  void initState() {
    super.initState();
  }

  Future<bool> future() async {
    try {
      messages = await MessageController.fetchMessages(widget.threadId);
      List<dynamic> requests = [];

      for (int i = 0; i < messages.length; i++) {
        if (messages[i].sender == Sender.user) {
          continue;
        }
        requests.add(
          {
            'id': messages[i].smsMessage.id!,
            'content': messages[i].smsMessage.body!
          },
        );
      }

      probabilities = await MessageController.analyze(requests);

      return true;
    } catch (error) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    TextTheme textTheme = Theme.of(context).textTheme;

    return Consumer<SettingModel>(
      builder: (context, value, child) => Scaffold(
        appBar: CustomAppBar(
          isBack: true,
          isSurface: true,
          data: widget.number,
        ),
        backgroundColor: value.brightness == Brightness.light
            ? const Color(0xFFF4F4F4)
            : const Color(0xFF030303),
        floatingActionButton: FloatingActionButton.large(
          onPressed: () => showDialog(
            context: context,
            builder: (context) => const ReportDialogView(),
          ),
          child: const Icon(Icons.report_outlined),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        body: FutureBuilder(
          future: future(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (probabilities.isEmpty ||
                  probabilities[0]['probability'] >= 0.0) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: ListView(
                        children: List<Widget>.generate(
                              messages.length,
                              (index) {
                                if (messages[index].sender == Sender.opponent) {
                                  for (int i = 0;
                                      i < probabilities.length;
                                      i++) {
                                    if (messages[index].smsMessage.id! ==
                                        probabilities[i]['id']) {
                                      return CustomChatAnalysis(
                                        isLeft: true,
                                        isAnalyzed: true,
                                        data: messages[index].smsMessage.body!,
                                        probability: probabilities[i]
                                            ['probability'],
                                      );
                                    }
                                  }

                                  return CustomChatAnalysis(
                                    isLeft: true,
                                    isAnalyzed: false,
                                    data: messages[index].smsMessage.body!,
                                    probability: 0.0,
                                  );
                                } else {
                                  return CustomChatAnalysis(
                                    isLeft: false,
                                    isAnalyzed: false,
                                    data: messages[index].smsMessage.body!,
                                    probability: 0.0,
                                  );
                                }
                              },
                            ) +
                            <Widget>[const SizedBox(height: 16)],
                      ),
                    ),
                  ],
                );
              } else if (probabilities[0]['probability'] == -2.0) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'ERROR',
                        style: textTheme.headlineLarge?.copyWith(
                          color: colorScheme.onSurface,
                        ),
                      ),
                      Text(
                        'SERVER',
                        style: textTheme.displayLarge?.copyWith(
                          color: colorScheme.onSurface,
                        ),
                      )
                    ],
                  ),
                );
              } else {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'ERROR',
                        style: textTheme.headlineLarge?.copyWith(
                          color: colorScheme.onSurface,
                        ),
                      ),
                      Text(
                        (-probabilities[0]['probability'].toInt()).toString(),
                        style: textTheme.displayLarge?.copyWith(
                          color: colorScheme.onSurface,
                        ),
                      )
                    ],
                  ),
                );
              }
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
      ),
    );
  }
}
