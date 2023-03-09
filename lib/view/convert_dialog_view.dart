import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_voice/model/setting_model.dart';
import 'package:the_voice/view/analysis_view.dart';
import 'package:the_voice/view/case_view.dart';

class ConvertDialogView extends StatelessWidget {
  static String route = 'convert_dialog_view';
  final bool isName;
  final bool isCall;

  const ConvertDialogView({
    super.key,
    required this.isName,
    required this.isCall,
  });

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    TextTheme textTheme = Theme.of(context).textTheme;

    if (isName) {
      return Consumer<SettingModel>(
        builder: (context, value, child) => AlertDialog(
          icon: const Icon(Icons.sync),
          title: Text(
            value.language == Language.english ? 'Analysis?' : '분석하시겠습니까?',
          ),
          content: const ListTile(
            leading: CircleAvatar(radius: 32),
            title: Text('Name'),
            subtitle: Text('010-0000-0000'),
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
              onPressed: isCall
                  ? () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, AnalysisView.route);
                    }
                  : () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, CaseView.route);
                    },
              child: Text(
                value.language == Language.english ? 'Analysis' : '분석',
              ),
            ),
          ],
        ),
      );
    } else {
      return Consumer<SettingModel>(
        builder: (context, value, child) => AlertDialog(
          icon: const Icon(Icons.change_circle),
          title: Text(
            value.language == Language.english ? 'Analysis?' : '분석하시겠습니까?',
          ),
          content: const ListTile(
            leading: Icon(Icons.image),
            title: Text('010-0000-0000'),
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
                Navigator.pushNamed(context, AnalysisView.route);
              },
              child: Text(
                value.language == Language.english ? 'Analysis' : '분석',
              ),
            ),
          ],
        ),
      );
    }
  }
}
