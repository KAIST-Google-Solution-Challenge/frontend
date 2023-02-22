import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_voice/model/setting_model.dart';

class ReportDialogView extends StatelessWidget {
  static String route = 'report_dialog_view';

  ReportDialogView({super.key});

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    TextTheme textTheme = Theme.of(context).textTheme;

    return Consumer<SettingModel>(
      builder: (context, value, child) => AlertDialog(
        icon: Icon(Icons.report),
        title: Text(
          value.language == Language.english ? 'Report?' : '신고하시겠습니까?',
        ),
        content: ListTile(
          leading: CircleAvatar(radius: 32),
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
            onPressed: () {
              Navigator.pop(context);
              // Todo: Implement Call to 1332
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
