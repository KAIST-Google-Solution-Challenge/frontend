import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  late String fileString;
  if (await fileController.fileExists()) {
    fileString = await fileController.fileReadAsString();
  } else {
    await fileController.fileInit();
    fileString = await fileController.fileReadAsString();
  }

  runApp(
    TheVoice(
      backgroundController: backgroundController,
      fileString: fileString,
    ),
  );
}

class TheVoice extends StatelessWidget {
  final BackgroundController backgroundController;
  final String fileString;

  const TheVoice({
    super.key,
    required this.backgroundController,
    required this.fileString,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SettingModel>(
      create: (context) {
        SettingModel settingModel = SettingModel(
          backgroundController: backgroundController,
        );
        settingModel.init(fileString);

        return settingModel;
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
