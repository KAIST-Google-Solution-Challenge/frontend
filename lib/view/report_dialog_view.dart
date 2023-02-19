import 'package:flutter/material.dart';

class ReportDialogView extends StatelessWidget {
  static String route = 'report_dialog_view';

  ReportDialogView({super.key});

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    TextTheme textTheme = Theme.of(context).textTheme;

    return AlertDialog(
      icon: Icon(Icons.report),
      title: Text('Report?'),
      content: ListTile(
        leading: Icon(Icons.image),
        title: Text('FSS'),
        subtitle: Text('1332'),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            'Cancel',
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
          child: Text('Report'),
        ),
      ],
    );
  }
}
