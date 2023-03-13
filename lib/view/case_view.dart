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
  MessageController messageController = MessageController();
  late List<MessageModel> messages;
  late List<dynamic> probabilities;

  @override
  void initState() {
    super.initState();
    messageController.init();
  }

  Future<bool> future() async {
    messages = await messageController.fetchMessages(widget.threadId);
    List<RequestModel> requests = List.generate(
      messages.length,
      (index) => RequestModel(
        id: index,
        content: messages[index].smsMessage.body!,
      ),
    );
    probabilities = await messageController.analyze(requests);
    return true;
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;

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
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: ListView(
                      children: List<Widget>.generate(
                            messages.length,
                            (index) {
                              return messages[index].sender == Sender.opponent
                                  ? CustomChatAnalysis(
                                      isLeft: true,
                                      isAnalyzed: true,
                                      data: messages[index].smsMessage.body!,
                                      probability: probabilities[index],
                                    )
                                  : CustomChatAnalysis(
                                      isLeft: false,
                                      isAnalyzed: false,
                                      data: messages[index].smsMessage.body!,
                                      probability: 0,
                                    );
                            },
                          ) +
                          <Widget>[const SizedBox(height: 16)],
                    ),
                  ),
                ],
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
      ),
    );
  }
}
