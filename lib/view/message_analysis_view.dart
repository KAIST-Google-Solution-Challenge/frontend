import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_voice/controller/message_controller.dart';
import 'package:the_voice/model/chart_model.dart';
import 'package:the_voice/model/chat_model.dart';
import 'package:the_voice/model/build_model.dart';
import 'package:the_voice/model/setting_model.dart';
import 'package:the_voice/view/report_dialog_view.dart';

class MessageAnalysisView extends StatefulWidget {
  final String number;
  final int threadId;

  const MessageAnalysisView({
    super.key,
    required this.number,
    required this.threadId,
  });

  @override
  State<MessageAnalysisView> createState() => _MessageAnalysisViewState();
}

class _MessageAnalysisViewState extends State<MessageAnalysisView> {
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
    ColorScheme cs = Theme.of(context).colorScheme;
    TextTheme tt = Theme.of(context).textTheme;

    return Consumer<SettingModel>(
      builder: (context, value, child) => Scaffold(
        appBar: BuildAppBar(pushed: true, colored: false, title: widget.number),
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
        body: _buildBody(cs, tt),
      ),
    );
  }

  Widget _buildBody(ColorScheme colorScheme, TextTheme textTheme) {
    return FutureBuilder(
      future: future(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (probabilities.isEmpty || probabilities[0]['probability'] >= 0.0) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: ListView(
                    children: List<Widget>.generate(
                          messages.length,
                          (index) {
                            if (messages[index].sender == Sender.opponent) {
                              for (int i = 0; i < probabilities.length; i++) {
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
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}

class CustomChatAnalysis extends StatelessWidget {
  final bool isLeft;
  final bool isAnalyzed;
  final String data;
  final double probability;

  const CustomChatAnalysis({
    super.key,
    required this.isLeft,
    required this.isAnalyzed,
    required this.data,
    required this.probability,
  });

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    TextTheme textTheme = Theme.of(context).textTheme;

    if (isLeft) {
      return Column(
        children: [
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const SizedBox(width: 16),
              Container(
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                      bottomRight: Radius.circular(16),
                    ),
                    color: colorScheme.surface),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(process(data)),
                ),
              ),
              isAnalyzed
                  ? Row(
                      children: [
                        const SizedBox(width: 4),
                        DoughnutChart(
                            isChat: true, radius: 10, probability: probability),
                        const SizedBox(width: 4),
                        Text(
                          '$probability%',
                          style: textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    )
                  : const SizedBox()
            ],
          )
        ],
      );
    } else {
      return Column(
        children: [
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              isAnalyzed
                  ? Row(
                      children: [
                        Text(
                          '$probability%',
                          style: textTheme.bodyMedium,
                        ),
                        const SizedBox(width: 4),
                        DoughnutChart(
                            isChat: true, radius: 10, probability: probability),
                        const SizedBox(width: 4),
                      ],
                    )
                  : const SizedBox(),
              Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                    bottomLeft: Radius.circular(16),
                  ),
                  color: colorScheme.primary.withAlpha(13),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    process(data),
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
            ],
          )
        ],
      );
    }
  }

  String process(String data) {
    List<String> lines = [];

    int cnt = 0;
    String line = "";
    for (int i = 0; i < data.length; i += 1) {
      if (i == data.length - 1) {
        cnt += 1;
        line += data[i];
        lines.add(line);
      } else if (cnt == 20 || data[i] == '\n') {
        lines.add(line);
        cnt = 1;
        line = data[i];
      } else {
        cnt += 1;
        line += data[i];
      }
    }

    return lines.join('\n');
  }
}
