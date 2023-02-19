import 'package:flutter/material.dart';
import 'package:the_voice/view/call_view.dart';
import 'package:the_voice/view/home_view.dart';
import 'package:provider/provider.dart';
import 'package:the_voice/model/setting_model.dart';
import 'package:the_voice/view/message_view.dart';

void main() {
  runApp(const TheVoice());
}

class TheVoice extends StatelessWidget {
  const TheVoice({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SettingModel>(
      create: (context) => SettingModel(),
      child: Consumer<SettingModel>(
        builder: (context, value, child) => MaterialApp(
          initialRoute: HomeView.route,
          routes: {
            HomeView.route: (context) => HomeView(),
            CallView.route: (context) => CallView(),
            MessageView.route: (context) => MessageView(),
          },
          theme: ThemeData(
            useMaterial3: true,
            colorSchemeSeed: Colors.blue,
            brightness: value.brightness,
          ),
        ),
      ),
    );
  }
}
