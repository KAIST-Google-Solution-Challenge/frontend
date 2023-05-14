import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_voice/model/setting_model.dart';
import 'package:url_launcher/url_launcher_string.dart';

class ReportDialogView extends StatelessWidget {
  const ReportDialogView({super.key});

  @override
  Widget build(BuildContext context) {
    ColorScheme cs = Theme.of(context).colorScheme;
    TextTheme tt = Theme.of(context).textTheme;

    return Consumer<SettingModel>(
      builder: (_, value, __) {
        final bool lang = value.language == Language.english;

        return AlertDialog(
          icon: const Icon(Icons.report),
          title: Text(lang ? 'Report?' : '신고하시겠습니까?'),
          content: ListTile(
            title: Text(lang ? 'FSS' : '금융감독원'),
            subtitle: Text(lang ? '1-877-382-4357' : '1332'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                lang ? 'Cancel' : '취소',
                style: tt.labelLarge?.copyWith(
                  color: cs.onSurfaceVariant,
                ),
              ),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                await _launchUrlString(lang);
              },
              child: Text(lang ? 'Report' : '신고'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _launchUrlString(bool lang) async {
    if (lang) {
      if (await canLaunchUrlString('tel:18773824357')) {
        await launchUrlString('tel:18773824357');
      }
    } else {
      if (await canLaunchUrlString('tel:1332')) {
        await launchUrlString('tel:1332');
      }
    }
  }
}
