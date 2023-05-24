import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_voice/provider/setting_provider.dart';
import 'package:the_voice/view/profile_view.dart';

class BuildAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool pushed; // is pushed by navigator?
  final String title;

  const BuildAppBar({
    super.key,
    required this.pushed,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    TextTheme tt = Theme.of(context).textTheme;
    SettingProvider sm = context.watch<SettingProvider>();
    bool largeFont = sm.largeFont;

    if (pushed) {
      return AppBar(
        backgroundColor: Colors.transparent,
        title: largeFont ? Text(title, style: tt.headlineLarge) : Text(title),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
        ),
      );
    } else {
      return AppBar(
        backgroundColor: Colors.transparent,
        title: largeFont ? Text(title, style: tt.headlineLarge) : Text(title),
        actions: [
          IconButton(
            onPressed: () => Navigator.push(context, _buildProfileViewRoute()),
            icon: const Icon(Icons.person),
          ),
        ],
      );
    }
  }

  Route _buildProfileViewRoute() {
    return PageRouteBuilder(
      pageBuilder: (_, __, ___) => const ProfileView(),
      transitionsBuilder: (_, animation, __, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        final curveTween = CurveTween(curve: Curves.ease);
        final tween = Tween(begin: begin, end: end).chain(curveTween);
        final offsetAnimation = animation.drive(tween);

        return SlideTransition(position: offsetAnimation, child: child);
      },
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
