import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_voice/model/custom_widget_model.dart';
import 'package:the_voice/model/setting_model.dart';
import 'package:the_voice/view/report_dialog_view.dart';

class CaseView extends StatelessWidget {
  static String route = 'case_view';

  CaseView({super.key});

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Consumer<SettingModel>(
      builder: (context, value, child) => Scaffold(
        appBar: CustomAppBar(
          isBack: true,
          isSurface: true,
          data: '010-0000-0000',
        ),
        backgroundColor: value.brightness == Brightness.light
            ? Color(0xFFF4F4F4)
            : Color(0xFF030303),
        floatingActionButton: FloatingActionButton.large(
          onPressed: () => showDialog(
            context: context,
            builder: (context) => ReportDialogView(),
          ),
          child: Icon(Icons.report_outlined),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        body: Stack(
          alignment: AlignmentDirectional.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: ListView(
                    children: List<Widget>.generate(
                          24,
                          (index) => index % 2 == 0
                              ? CustomChatAnalysis(
                                  isLeft: true,
                                  data: 'Opponent Text',
                                  probability: 64,
                                )
                              : CustomChatAnalysis(
                                  isLeft: false,
                                  data: 'My Text',
                                  probability: 16,
                                ),
                        ) +
                        <Widget>[SizedBox(height: 16)],
                  ),
                ),
              ],
            ),
            Row(
              children: [
                SizedBox(width: 16),
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.navigate_before),
                ),
                Expanded(child: SizedBox()),
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.navigate_next),
                ),
                SizedBox(width: 16),
              ],
            )
          ],
        ),
      ),
    );
  }
}
