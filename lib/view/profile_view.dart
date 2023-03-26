import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_voice/controller/authentication_controller.dart';
import 'package:the_voice/model/custom_widget_model.dart';
import 'package:the_voice/model/setting_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:math';

import 'package:the_voice/view/emergency_contact_dialog_view.dart';

class ProfileView extends StatelessWidget {
  static String route = 'profile_view';

  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    AuthenticationController authenticationController =
        AuthenticationController();
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    TextTheme textTheme = Theme.of(context).textTheme;

    return Consumer<SettingModel>(
      builder: (context, value, child) => Scaffold(
        appBar: CustomAppBar(
          isBack: true,
          isSurface: true,
          data: value.language == Language.english ? 'Profile' : '프로필',
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            firebaseAuth.currentUser == null
                ? const CircleAvatar(radius: 64)
                : Image(
                    width: 100,
                    height: 100,
                    image: NetworkImage(
                      firebaseAuth.currentUser!.photoURL!,
                    ),
                  ),
            const SizedBox(height: 16),
            Text(
              firebaseAuth.currentUser == null
                  ? 'Guest'
                  : firebaseAuth.currentUser!.displayName!,
              style: textTheme.headlineSmall,
            ),
            Text(
              firebaseAuth.currentUser == null
                  ? 'guest${Random().nextInt(9999) + 1}@the-voice.app'
                  : firebaseAuth.currentUser!.email!,
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: () => authenticationController.signInWithGoogle(),
              child: Text(
                value.language == Language.english
                    ? 'Connect with Google'
                    : '구글 연동',
              ),
            ),
            const SizedBox(height: 64),
            Row(
              children: [
                const SizedBox(width: 32),
                Expanded(
                  child: Consumer<SettingModel>(
                    builder: (context, value, child) => Column(
                      children: [
                        ListTile(
                          leading: Icon(Icons.add_call),
                          title: Text(
                            value.language == Language.english
                                ? 'Emergency Contact'
                                : '비상 연락처',
                            style: textTheme.labelLarge,
                          ),
                          subtitle: Text(
                            value.emergencyContact.isEmpty
                                ? value.language == Language.english
                                    ? 'Not Enrolled'
                                    : '등록되지 않음'
                                : value.emergencyContact,
                            style: textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                          trailing: IconButton(
                            icon: Icon(Icons.add),
                            onPressed: () => showDialog(
                              context: context,
                              builder: (context) =>
                                  EmergencyContactDialogView(),
                            ),
                          ),
                        ),
                        Divider(),
                        ListTile(
                          leading: const Icon(Icons.autorenew),
                          title: Text(
                            value.language == Language.english
                                ? 'Auto Analysis'
                                : '자동 분석',
                            style: textTheme.labelLarge,
                          ),
                          trailing: Switch(
                            value: value.autoAnalysis,
                            onChanged: (_) async =>
                                await value.changeAutoAnalysis(),
                          ),
                        ),
                        Divider(),
                        ListTile(
                          leading: const Icon(Icons.sunny),
                          title: Text(
                            value.language == Language.english
                                ? 'Dark Mode'
                                : '다크 모드',
                            style: textTheme.labelLarge,
                          ),
                          trailing: Switch(
                            value: value.brightness == Brightness.light
                                ? false
                                : true,
                            onChanged: (_) => value.changeBrightness(),
                          ),
                        ),
                        Divider(),
                        ListTile(
                          leading: const Icon(Icons.language),
                          title: Text(
                            value.language == Language.english
                                ? 'Language'
                                : '언어',
                            style: textTheme.labelLarge,
                          ),
                          subtitle: Text(
                            value.language == Language.english
                                ? value.language == Language.english
                                    ? 'English'
                                    : '영어'
                                : value.language == Language.english
                                    ? 'Korean'
                                    : '한국어',
                            style: textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                          trailing: Switch(
                            value: value.language == Language.english
                                ? false
                                : true,
                            onChanged: (_) => value.changeLanguage(),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 32),
              ],
            )
          ],
        ),
      ),
    );
  }
}
