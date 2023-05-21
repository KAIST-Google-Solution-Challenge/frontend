import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_voice/controller/call_controller.dart';
import 'package:the_voice/model/setting_model.dart';
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

    return FutureBuilder(
      future: CallController.fetchCalls(),
      builder: (_, snapshot) {
        if (snapshot.hasData) {
          return ListView(
            children: List<Widget>.generate(
              snapshot.data!.length,
              (index) {
                int minute = snapshot.data![index].duration! ~/ 60;
                int second = snapshot.data![index].duration! % 60;

                nextHeader = DateTime.fromMillisecondsSinceEpoch(
                  snapshot.data![index].timestamp!,
                ).toIso8601String().substring(0, 10);

                BuildListTile customCallListTile = BuildListTile(
                  leading: const CircleAvatar(radius: 32),
                  isHeader: currHeader != nextHeader,
                  header: nextHeader,
                  title: snapshot.data![index].number!,
                  subtitle: snapshot.data![index].callType
                      .toString()
                      .substring(9)
                      .toLowerCase(),
                  trailing:
                      '${minute < 10 ? '0$minute' : minute}:${second < 10 ? '0$second' : second}',
                  datetime: DateTime.fromMillisecondsSinceEpoch(
                    snapshot.data![index].timestamp!,
                  ).toIso8601String(),
                );

                currHeader = nextHeader;

                return customCallListTile;
              },
            ),
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}

class BuildListTile extends StatelessWidget {
  final bool isHeader;
  final Widget leading;
  final String header;
  final String title;
  final String subtitle;
  final String trailing;
  final String datetime;

  const BuildListTile({
    super.key,
    required this.isHeader,
    required this.leading,
    required this.header,
    required this.title,
    required this.subtitle,
    required this.trailing,
    required this.datetime,
  });

  @override
  Widget build(BuildContext context) {
    TextTheme tt = Theme.of(context).textTheme;
    SettingModel sm = context.watch<SettingModel>();
    bool largeFont = sm.largeFont;

    void onTap() {
      showDialog(
        context: context,
        builder: (context) => CallAnalysisDialogView(
          leading: leading,
          title: title,
          subtitle: subtitle,
          trailing: trailing,
          datetime: datetime,
        ),
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
          leading: leading,
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
