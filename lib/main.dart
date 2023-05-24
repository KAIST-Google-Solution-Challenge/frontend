import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:the_voice/controller/background_controller.dart';
import 'package:the_voice/controller/call_controller.dart';
import 'package:the_voice/controller/contact_controller.dart';
import 'package:the_voice/controller/file_controller.dart';
import 'package:the_voice/controller/message_controller.dart';
import 'package:the_voice/home.dart';
import 'package:provider/provider.dart';
import 'package:the_voice/provider/setting_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await _requestPermission();

  runApp(const TheVoice());
}

class TheVoice extends StatelessWidget {
  const TheVoice({super.key});

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
      future: _initializeController(),
      builder: (_, snapshot) {
        if (snapshot.hasData) {
          return ChangeNotifierProvider<SettingProvider>(
            create: (_) => _createSettingModel(),
            builder: (_, child) => Consumer<SettingProvider>(
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

SettingProvider _createSettingModel() {
  SettingProvider settingProvider = SettingProvider();
  settingProvider.init();

  return settingProvider;
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
  if (!(await Permission.notification.status).isGranted) {
    await Permission.notification.request();
  }
  if (!(await Permission.manageExternalStorage.status).isGranted) {
    await Permission.manageExternalStorage.request();
  }
}

Future<bool> _initializeController() async {
  await BackgroundController.init();
  await FileController.init();
  await ContactController.fetchContacts();
  await CallController.fetchCalls();
  await MessageController.fetchMessages();

  return true;
}
