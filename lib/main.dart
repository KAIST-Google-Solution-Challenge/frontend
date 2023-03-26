import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:the_voice/controller/background_controller.dart';
import 'package:the_voice/controller/file_controller.dart';
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

  final BackgroundController backgroundController = BackgroundController();
  await backgroundController.init();

  final FileController fileController = FileController();

  runApp(
    TheVoice(
      backgroundController: backgroundController,
    ),
  );
}

class TheVoice extends StatelessWidget {
  final BackgroundController backgroundController;

  const TheVoice({super.key, required this.backgroundController});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SettingModel>(
      create: (context) {
        return SettingModel(
          backgroundController: backgroundController,
          emergencyContact: '',
          autoAnalysis: false,
          brightness: Brightness.light,
          language: Language.english,
        );
      },
      builder: (context, child) => Consumer<SettingModel>(
        builder: (context, value, child) => MaterialApp(
          debugShowCheckedModeBanner: false,
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
