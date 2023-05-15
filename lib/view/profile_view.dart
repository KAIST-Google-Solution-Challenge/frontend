import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_voice/controller/authentication_controller.dart';
import 'package:the_voice/model/build_model.dart';
import 'package:the_voice/model/setting_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:math';
import 'package:the_voice/view/emergency_contact_dialog_view.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    AuthenticationController ac = AuthenticationController();
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    ColorScheme cs = Theme.of(context).colorScheme;
    TextTheme tt = Theme.of(context).textTheme;

    return Consumer<SettingModel>(
      builder: (_, value, __) => Scaffold(
        appBar: _buildAppBar(value),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ..._buildInfo(firebaseAuth, cs, tt, ac, value),
            const SizedBox(height: 64),
            Row(
              children: [
                const SizedBox(width: 32),
                Expanded(
                  child: Column(
                    children: _buildSetting(context, cs, tt, value),
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

  PreferredSizeWidget _buildAppBar(SettingModel sm) {
    return BuildAppBar(pushed: true, colored: false, title: _getTitle(sm));
  }

  String _getTitle(SettingModel sm) {
    return sm.language == Language.english ? 'Profile' : '프로필';
  }

  List<Widget> _buildInfo(
    FirebaseAuth firebaseAuth,
    ColorScheme colorScheme,
    TextTheme textTheme,
    AuthenticationController authenticationController,
    SettingModel settingModel,
  ) {
    return [
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
          settingModel.language == Language.english
              ? 'Connect with Google'
              : '구글 연동',
        ),
      ),
    ];
  }

  List<Widget> _buildSetting(
    BuildContext context,
    ColorScheme colorScheme,
    TextTheme textTheme,
    SettingModel value,
  ) {
    final bool lang = value.language == Language.english;

    return [
      ListTile(
        leading: const Icon(Icons.add_call),
        title: Text(
          lang ? 'Emergency Contact' : '비상 연락처',
          style: textTheme.labelLarge,
        ),
        subtitle: Text(
          value.emergencyContact.isEmpty
              ? lang
                  ? 'Not Enrolled'
                  : '등록되지 않음'
              : value.emergencyContact,
          style: textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.add),
          onPressed: () => showDialog(
            context: context,
            builder: (_) => const EmergencyContactDialogView(),
          ),
        ),
      ),
      const Divider(),
      ListTile(
        leading: const Icon(Icons.autorenew),
        title: Text(
          lang ? 'Auto Analysis' : '자동 분석',
          style: textTheme.labelLarge,
        ),
        trailing: Switch(
          value: value.autoAnalysis,
          onChanged: (_) async => await value.changeAutoAnalysis(),
        ),
      ),
      const Divider(),
      ListTile(
        leading: Icon(
          value.brightness == Brightness.light
              ? Icons.wb_sunny_outlined
              : Icons.brightness_3,
        ),
        title: Text(
          lang ? 'Dark Mode' : '다크 모드',
          style: textTheme.labelLarge,
        ),
        trailing: Switch(
          value: value.brightness != Brightness.light,
          onChanged: (_) => value.changeBrightness(),
        ),
      ),
      const Divider(),
      ListTile(
        leading: const Icon(Icons.language),
        title: Text(
          lang ? 'Language' : '언어',
          style: textTheme.labelLarge,
        ),
        subtitle: Text(
          lang ? 'English' : '한국어',
          style: textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        trailing: Switch(
          value: value.language != Language.english,
          onChanged: (_) => value.changeLanguage(),
        ),
      )
    ];
  }
}
