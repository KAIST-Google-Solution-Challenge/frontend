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
    return FutureBuilder(
      future: _initializeController(bc, fc),
      builder: (context, snapshot) {
        if (snapshot.data ?? false) {
          return ChangeNotifierProvider<SettingModel>(
            create: (context) {
              SettingModel settingModel = SettingModel(
                backgroundController: bc,
              );
              settingModel.init(fc.fileReadAsStringSync());

              return settingModel;
            },
            builder: (context, child) => Consumer<SettingModel>(
              builder: (context, value, child) => MaterialApp(
                debugShowCheckedModeBanner: false,
                home: Home(sm: value),
                theme: ThemeData(
                  useMaterial3: true,
                  colorSchemeSeed: Colors.blue,
                  brightness: value.brightness,
                  appBarTheme: AppBarTheme(
                    systemOverlayStyle: SystemUiOverlayStyle(
                      statusBarColor: Colors.transparent,
                      statusBarIconBrightness:
                          value.brightness == Brightness.light
                              ? Brightness.dark
                              : Brightness.light,
                    ),
                  ),
                ),
              ),
            ),
          );
        } else {
          return _buildLoading(context);
        }
      },
    );
  }

  MaterialApp _buildLoading(BuildContext context) {
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
  BackgroundController bc,
  FileController fc,
) async {
  await bc.init();

  if (!await fc.fileExists()) {
    await fc.fileInit();
  }

  return true;
}
