import 'package:call_log/call_log.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_voice/controller/call_controller.dart';
import 'package:the_voice/provider/setting_provider.dart';
import 'package:the_voice/view/call_analysis_dialog_view.dart';

class CallView extends StatefulWidget {
  const CallView({super.key});

  @override
  State<CallView> createState() => _CallViewState();
}

class _CallViewState extends State<CallView> {
  @override
  Widget build(BuildContext context) {
    String currHeader = '';
    String nextHeader = '';

    return NotificationListener<ScrollNotification>(
      onNotification: (scrollNotification) {
        if (scrollNotification.metrics.pixels ==
            scrollNotification.metrics.maxScrollExtent) {
          setState(() {
            CallController.loadCalls();
          });
        }

        return true;
      },
      child: ListView(
        children: List<Widget>.generate(
          CallController.calls.length,
          (index) {
            nextHeader = DateTime.fromMillisecondsSinceEpoch(
              CallController.calls[index].timestamp!,
            ).toIso8601String().substring(0, 10);

            BuildListTile buildListTile = BuildListTile(
              isHeader: currHeader != nextHeader,
              header: nextHeader,
              callLogEntry: CallController.calls[index],
            );

            currHeader = nextHeader;

            return buildListTile;
          },
        ),
      ),
    );
  }
}

class BuildListTile extends StatelessWidget {
  final bool isHeader;
  final String header;
  final CallLogEntry callLogEntry;

  const BuildListTile({
    super.key,
    required this.isHeader,
    required this.header,
    required this.callLogEntry,
  });

  @override
  Widget build(BuildContext context) {
    TextTheme tt = Theme.of(context).textTheme;
    SettingProvider sm = context.watch<SettingProvider>();
    bool largeFont = sm.largeFont;

    int minute = callLogEntry.duration! ~/ 60;
    int second = callLogEntry.duration! % 60;

    String title =
        callLogEntry.name! != '' ? callLogEntry.name! : callLogEntry.number!;
    String subtitle =
        callLogEntry.callType.toString().substring(9).toLowerCase();
    String trailing =
        '${minute < 10 ? '0$minute' : minute}:${second < 10 ? '0$second' : second}';

    void onTap() {
      showDialog(
        context: context,
        builder: (context) =>
            CallAnalysisDialogView(callLogEntry: callLogEntry),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        isHeader
            ? Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  header,
                  style: largeFont ? tt.bodyLarge : tt.labelMedium,
                ),
              )
            : const SizedBox(),
        ListTile(
          leading: const CircleAvatar(radius: 32),
          title: largeFont ? Text(title, style: tt.titleLarge) : Text(title),
          subtitle:
              largeFont ? Text(subtitle, style: tt.bodyLarge) : Text(subtitle),
          trailing:
              largeFont ? Text(trailing, style: tt.labelLarge) : Text(trailing),
          onTap: onTap,
        ),
      ],
    );
  }
}
