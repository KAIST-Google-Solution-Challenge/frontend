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
  CallController callController = CallController();

  @override
  void initState() {
    super.initState();
    callController.init();
  }

  String processTitle(String title) {
    // print("title accessing...");
    // print(title.length);
    // print(title);
    if (title[0] == '+') {
      // print(0);
      title = title.substring(1);
    } else if(title.length < 4){
      return title;
    } else if (title[3] == '-' && title[8] == '-') {
      // print(3);
      // print(8);
      title = title.substring(0, 3) +
          title.substring(4, 8) +
          title.substring(9, 13);
    }

    return title;
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
          future: callController.fetchCalls(),
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
                    nextHeader = DateTime.fromMillisecondsSinceEpoch(
                      snapshot.data![index].timestamp!,
                    ).toIso8601String().substring(0, 10);

                    CustomCallListTile customCallListTile = CustomCallListTile(
                      leading: const CircleAvatar(radius: 32),
                      isHeader: currHeader != nextHeader,
                      header: nextHeader,
                      title: processTitle(snapshot.data![index].number!),
                      subtitle: snapshot.data![index].callType
                          .toString()
                          .substring(9)
                          .toLowerCase(),
                      trailing: snapshot.data![index].duration.toString(),
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
