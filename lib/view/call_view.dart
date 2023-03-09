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

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;

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
                  (index) => CustomCallListTile(
                    leading: const CircleAvatar(radius: 32),
                    isHeader: true,
                    header: snapshot.data![index].timestamp.toString(),
                    title: snapshot.data![index].number.toString(),
                    subtitle: snapshot.data![index].callType
                        .toString()
                        .substring(9)
                        .toLowerCase(),
                    trailing: snapshot.data![index].duration.toString(),
                  ),
                ),
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
        bottomNavigationBar: const CustomNavigationBar(selectedIndex: 0),
      ),
    );
  }
}
