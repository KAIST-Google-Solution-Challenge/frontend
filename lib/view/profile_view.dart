import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_voice/model/custom_widget_model.dart';
import 'package:the_voice/model/setting_model.dart';

class ProfileView extends StatelessWidget {
  static String route = 'profile_view';

  ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    TextTheme textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: CustomAppBar(
        isBack: true,
        isSurface: true,
        data: 'Profile',
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 64,
          ),
          SizedBox(height: 16),
          Text('Seungho Jang', style: textTheme.headlineSmall),
          Text('develop0235@gmail.com',
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              )),
          SizedBox(height: 16),
          OutlinedButton(
            onPressed: () {},
            child: Text('Connect with Google'),
          ),
          SizedBox(height: 64),
          Row(
            children: [
              SizedBox(width: 32),
              Expanded(
                child: Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      color: Theme.of(context).colorScheme.outline,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                  child: Consumer<SettingModel>(
                    builder: (context, value, child) => Column(
                      children: [
                        ListTile(
                          leading: Icon(Icons.autorenew),
                          title: Text(
                            'Auto Analysis',
                            style: textTheme.labelLarge,
                          ),
                          trailing: Switch(
                            value: value.autoAnalysis,
                            onChanged: (_) => value.changeAutoAnalysis(),
                          ),
                        ),
                        ListTile(
                          leading: Icon(Icons.sunny),
                          title: Text(
                            'Dark Mode',
                            style: textTheme.labelLarge,
                          ),
                          trailing: Switch(
                            value: value.brightness == Brightness.light
                                ? false
                                : true,
                            onChanged: (_) => value.changeBrightness(),
                          ),
                        ),
                        ListTile(
                          leading: Icon(Icons.language),
                          title: Text(
                            'Language',
                            style: textTheme.labelLarge,
                          ),
                          subtitle: Text(
                            value.language == Language.english
                                ? 'English'
                                : 'Korean',
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
              ),
              SizedBox(width: 32),
            ],
          )
        ],
      ),
    );
  }
}
