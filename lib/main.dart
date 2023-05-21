import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:the_voice/controller/background_controller.dart';
import 'package:the_voice/controller/file_controller.dart';
import 'package:the_voice/home.dart';
import 'package:provider/provider.dart';
import 'package:the_voice/model/setting_model.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await _requestPermission();

  runApp(TheVoice());
}

class TheVoice extends StatelessWidget {
  final BackgroundController bc = BackgroundController();
  final FileController fc = FileController();

  TheVoice({super.key});

  @override
  Widget build(BuildContext context) {
    MaterialApp buildLoading() {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        ),
        theme: ThemeData(
          useMaterial3: true,
          colorSchemeSeed: Colors.blue,
          appBarTheme: const AppBarTheme(
            systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
            ),
          ),
        ),
      );
    }

    return FutureBuilder(
      future: _initializeController(bc, fc),
      builder: (_, snapshot) {
        if (snapshot.data ?? false) {
          return ChangeNotifierProvider<SettingModel>(
            create: (_) => _createSettingModel(bc, fc),
            builder: (_, child) => Consumer<SettingModel>(
              builder: (_, sm, __) => MaterialApp(
                debugShowCheckedModeBanner: false,
                home: const Home(),
                theme: ThemeData(
                  useMaterial3: true,
                  colorSchemeSeed: Colors.blue,
                  brightness: sm.brightness,
                  appBarTheme: AppBarTheme(
                    systemOverlayStyle: SystemUiOverlayStyle(
                      statusBarColor: Colors.transparent,
                      statusBarIconBrightness: sm.brightness == Brightness.light
                          ? Brightness.dark
                          : Brightness.light,
                    ),
                  ),
                ),
              ),
            ),
          );
        } else {
          return buildLoading();
        }
      },
    );
  }
}

SettingModel _createSettingModel(
  BackgroundController backgroundController,
  FileController fileController,
) {
  SettingModel settingModel = SettingModel(
    backgroundController: backgroundController,
  );
  settingModel.init(fileController.fileReadAsStringSync());

  return settingModel;
}

Future<void> _requestPermission() async {
  if (!(await Permission.phone.status).isGranted) {
    await Permission.phone.request();
  }
  if (!(await Permission.contacts.status).isGranted) {
    await Permission.contacts.request();
  }
  if (!(await Permission.sms.status).isGranted) {
    await Permission.sms.request();
  }
  if (!(await Permission.storage.status).isGranted) {
    await Permission.storage.request();
  }
  if (!(await Permission.manageExternalStorage.status).isGranted) {
    await Permission.manageExternalStorage.request();
  }
}

Future<bool> _initializeController(
  BackgroundController backgroundController,
  FileController fileController,
) async {
  await backgroundController.init();

  if (!await fileController.fileExists()) {
    await fileController.fileInit();
  } else if (fileController.fileReadAsStringSync().split(' ').length != 5) {
    await fileController.fileDelete();
    await fileController.fileInit();
  }

  return true;
}
