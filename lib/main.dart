import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:the_voice/view/analysis_view.dart';
import 'package:the_voice/view/call_view.dart';
import 'package:the_voice/view/case_view.dart';
import 'package:the_voice/view/home_view.dart';
import 'package:provider/provider.dart';
import 'package:the_voice/model/setting_model.dart';
import 'package:the_voice/view/message_view.dart';
import 'package:the_voice/view/profile_view.dart';
import 'package:the_voice/view/search_view.dart';

void main() async {
  runApp(const TheVoice());
  WidgetsFlutterBinding.ensureInitialized();
}

class TheVoice extends StatelessWidget {
  const TheVoice({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SettingModel>(
      create: (context) => SettingModel(),
      builder: (context, child) => Consumer<SettingModel>(
        builder: (context, value, child) => MaterialApp(
          initialRoute: HomeView.route,
          routes: {
            HomeView.route: (context) => const HomeView(),
            ProfileView.route: (context) => const ProfileView(),
            CallView.route: (context) => const CallView(),
            MessageView.route: (context) => const MessageView(),
            AnalysisView.route: (context) => const AnalysisView(),
            CaseView.route: (context) => const CaseView(),
            SearchView.route: (context) => const SearchView(),
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
