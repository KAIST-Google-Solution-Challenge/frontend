import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:the_voice/view/analysis_view.dart';
import 'package:the_voice/view/chat_view.dart';
import 'package:the_voice/view/call_view.dart';
import 'package:the_voice/view/case_view.dart';
import 'package:the_voice/view/home_view.dart';
import 'package:provider/provider.dart';
import 'package:the_voice/model/setting_model.dart';
import 'package:the_voice/view/message_view.dart';
import 'package:the_voice/view/profile_view.dart';

void main() async {
  runApp(const GetMaterialApp(home: TheVoice()));
  WidgetsFlutterBinding.ensureInitialized();
}

class TheVoice extends StatelessWidget {
  const TheVoice({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SettingModel>(
      create: (context) => SettingModel(),
      child: Consumer<SettingModel>(
        builder: (context, value, child) => MaterialApp(
          initialRoute: HomeView.route,
          routes: {
            HomeView.route: (context) => const HomeView(),
            ProfileView.route: (context) => const ProfileView(),
            CallView.route: (context) => CallView(),
            MessageView.route: (context) => MessageView(),
            ChatView.route: (context) => const ChatView(),
            AnalysisView.route: (context) => const AnalysisView(),
            CaseView.route: (context) => const CaseView(),
          },
          theme: ThemeData(
            useMaterial3: true,
            colorSchemeSeed: Colors.blue,
            brightness: value.brightness,
            appBarTheme: AppBarTheme(
              systemOverlayStyle: SystemUiOverlayStyle(
                statusBarColor: Colors.transparent,
                statusBarIconBrightness: value.brightness == Brightness.light
                    ? Brightness.dark
                    : Brightness.light,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
