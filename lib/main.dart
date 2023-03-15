import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:the_voice/view/call_view.dart';
import 'package:the_voice/view/home_view.dart';
import 'package:provider/provider.dart';
import 'package:the_voice/model/setting_model.dart';
import 'package:the_voice/view/message_view.dart';
import 'package:the_voice/view/profile_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const TheVoice());
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
