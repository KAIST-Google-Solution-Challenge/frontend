import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_voice/model/setting_model.dart';
import 'package:url_launcher/url_launcher_string.dart';

class ReportDialogView extends StatelessWidget {
  static String route = 'report_dialog_view';

  const ReportDialogView({super.key});

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    TextTheme textTheme = Theme.of(context).textTheme;

    return Consumer<SettingModel>(
      builder: (context, value, child) => AlertDialog(
        icon: const Icon(Icons.report),
        title: Text(
          value.language == Language.english ? 'Report?' : '신고하시겠습니까?',
        ),
        content: ListTile(
          title: Text(
            value.language == Language.english ? 'FSS' : '금융감독원',
          ),
          subtitle: Text(
            value.language == Language.english ? '1-877-382-4357' : '1332',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              value.language == Language.english ? 'Cancel' : '취소',
              style: textTheme.labelLarge?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              if (value.language == Language.english) {
                if (await canLaunchUrlString('tel:18773824357')) {
                  await launchUrlString('tel:18773824357');
                }
              } else {
                if (await canLaunchUrlString('tel:1332')) {
                  await launchUrlString('tel:1332');
                }
              }
            },
            child: Text(
              value.language == Language.english ? 'Report' : '신고',
            ),
          ),
        ],
      ),
    );
  }
}
