import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
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
              return ListView(
                children: List<Widget>.generate(
                  snapshot.data!.length,
                  (index) => CustomListTile(
                    isCall: true,
                    isDate: true,
                    isName: true,
                    date:
                        snapshot.data![index].timestamp.toString() ?? 'C Date',
                    name: snapshot.data![index].name ?? 'C Name',
                    number: snapshot.data![index].number ?? 'C Number',
                    time: snapshot.data![index].duration.toString() ?? 'C Time',
                  ),
                ),
              );
            } else {
              return ListView(
                children: List<Widget>.generate(
                  12,
                  (index) => const CustomListTile(
                    isCall: true,
                    isDate: true,
                    isName: true,
                    date: 'C Date',
                    name: 'C Name',
                    number: 'C 010-1111-1111',
                    time: 'C Time',
                  ),
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
