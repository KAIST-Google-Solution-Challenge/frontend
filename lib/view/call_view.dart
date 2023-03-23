import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:the_voice/controller/call_controller.dart';
import 'package:the_voice/model/custom_widget_model.dart';
import 'package:the_voice/model/setting_model.dart';

class CallView extends StatefulWidget {
  static String route = 'call_view';

  const CallView({super.key});

  @override
  State<CallView> createState() => _CallViewState();
}

class _CallViewState extends State<CallView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    String currHeader = '';
    String nextHeader = '';

    return Consumer<SettingModel>(
      builder: (context, value, child) => Scaffold(
        appBar: CustomAppBar(
          isBack: false,
          isSurface: true,
          data: value.language == Language.english ? 'Call' : '전화',
        ),
        body: FutureBuilder(
          future: CallController.fetchCalls(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              print(("data returned!"));
              print(snapshot.data!.length);
              return ListView(
                children: List<Widget>.generate(
                  snapshot.data!.length,
                  (index) {
                    // print("index: $index");
                    // print(snapshot.data![index]);
                    // print(snapshot.data![index].number!);

                    int minute = snapshot.data![index].duration! ~/ 60;
                    int second = snapshot.data![index].duration! % 60;

                    nextHeader = DateTime.fromMillisecondsSinceEpoch(
                      snapshot.data![index].timestamp!,
                    ).toIso8601String().substring(0, 10);

                    CustomCallListTile customCallListTile = CustomCallListTile(
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
              print(("data not yet returned!"));
              return Center(
                child: LoadingAnimationWidget.staggeredDotsWave(
                  color: colorScheme.primary,
                  size: 32,
                ),
              );
            }
          },
        ),
        bottomNavigationBar: const CustomNavigationBar(selectedIndex: 0),
      ),
    );
  }
}
