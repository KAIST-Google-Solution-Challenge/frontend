import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_voice/model/custom_widget_model.dart';
import 'package:the_voice/model/setting_model.dart';
import 'package:the_voice/view/report_dialog_view.dart';

class CaseView extends StatelessWidget {
  static String route = 'case_view';

  const CaseView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingModel>(
      builder: (context, value, child) => Scaffold(
        appBar: const CustomAppBar(
          isBack: true,
          isSurface: true,
          data: '010-0000-0000',
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
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ListView(
                children: List<Widget>.generate(
                      24,
                      (index) => index % 2 == 0
                          ? const CustomChatAnalysis(
                              isLeft: true,
                              data: 'Opponent Text',
                              probability: 64,
                            )
                          : const CustomChatAnalysis(
                              isLeft: false,
                              data: 'My Text',
                              probability: 16,
                            ),
                    ) +
                    <Widget>[const SizedBox(height: 16)],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
