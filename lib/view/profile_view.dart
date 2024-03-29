import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_voice/controller/authentication_controller.dart';
import 'package:the_voice/util/build.dart';
import 'package:the_voice/provider/setting_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:math';
import 'package:the_voice/view/emergency_contact_dialog_view.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  @override
  Widget build(BuildContext context) {
    AuthenticationController ac = AuthenticationController();
    FirebaseAuth fa = FirebaseAuth.instance;
    ColorScheme cs = Theme.of(context).colorScheme;
    TextTheme tt = Theme.of(context).textTheme;
    SettingProvider sm = context.watch<SettingProvider>();
    bool largeFont = sm.largeFont;
    bool brightness = sm.brightness == Brightness.light;
    bool lang = sm.language == Language.english;
    bool user = fa.currentUser == null;

    PreferredSizeWidget buildAppBar() {
      return BuildAppBar(pushed: true, title: lang ? 'Profile' : '프로필');
    }

    Widget buildInfo() {
      return Column(
        children: [
          user
              ? const CircleAvatar(radius: 64)
              : Image(
                  width: 100,
                  height: 100,
                  image: NetworkImage(fa.currentUser!.photoURL!),
                ),
          const SizedBox(height: 16),
          Text(
            user ? 'Guest' : fa.currentUser!.displayName!,
            style: largeFont ? tt.headlineLarge : tt.headlineSmall,
          ),
          Text(
            user
                ? 'guest${Random().nextInt(9999) + 1}@the-voice.app'
                : fa.currentUser!.email!,
            style: largeFont
                ? tt.bodyLarge?.copyWith(color: cs.onSurfaceVariant)
                : tt.bodySmall?.copyWith(color: cs.onSurfaceVariant),
          ),
          const SizedBox(height: 16),
          OutlinedButton(
            onPressed: () {
              setState(() {
                ac.signInWithGoogle();
              });
            },
            child: largeFont
                ? Text(
                    lang ? 'Connect with Google' : '구글 연동',
                    style: tt.bodyLarge,
                  )
                : Text(
                    lang ? 'Connect with Google' : '구글 연동',
                  ),
          ),
        ],
      );
    }

    Widget buildSetting() {
      TextStyle? titleStyle = largeFont ? tt.titleLarge : tt.labelLarge;
      TextStyle? subtitleStyle = largeFont
          ? tt.bodyLarge?.copyWith(color: cs.onSurfaceVariant)
          : tt.bodySmall?.copyWith(color: cs.onSurfaceVariant);
      return Column(
        children: [
          ListTile(
            leading: const Icon(Icons.add_call),
            title: Text(
              lang ? 'Emergency Contact' : '비상 연락처',
              style: titleStyle,
            ),
            subtitle: Text(
              sm.emergencyContact.isEmpty
                  ? lang
                      ? 'Not Enrolled'
                      : '등록되지 않음'
                  : sm.emergencyContact,
              style: subtitleStyle,
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
              style: titleStyle,
            ),
            trailing: Switch(
              value: sm.autoAnalysis,
              onChanged: (_) async => await sm.changeAutoAnalysis(),
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.format_size),
            title: Text(
              lang ? 'Large Font' : '큰글 모드',
              style: titleStyle,
            ),
            trailing: Switch(
              value: sm.largeFont,
              onChanged: (_) async => sm.changeLargeFont(),
            ),
          ),
          const Divider(),
          ListTile(
            leading: Icon(brightness ? Icons.brightness_7 : Icons.brightness_2),
            title: Text(
              brightness
                  ? (lang ? 'Light Mode' : '라이트 모드')
                  : (lang ? 'Dark Mode' : '다크 모드'),
              style: titleStyle,
            ),
            trailing: Switch(
              value: !brightness,
              onChanged: (_) => sm.changeBrightness(),
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.language),
            title: Text(
              lang ? 'Language' : '언어',
              style: titleStyle,
            ),
            subtitle: Text(
              lang ? 'English' : '한국어',
              style: subtitleStyle,
            ),
            trailing: Switch(
              value: !lang,
              onChanged: (_) => sm.changeLanguage(),
            ),
          )
        ],
      );
    }

    return Scaffold(
      appBar: buildAppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          buildInfo(),
          const SizedBox(height: 64),
          Row(
            children: [
              const SizedBox(width: 32),
              Expanded(
                child: buildSetting(),
              ),
              const SizedBox(width: 32),
            ],
          )
        ],
      ),
    );
  }
}
