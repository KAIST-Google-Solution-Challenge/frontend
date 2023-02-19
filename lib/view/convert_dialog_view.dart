import 'package:flutter/material.dart';
import 'package:the_voice/view/call_chat_view.dart';

class ConvertDialogView extends StatelessWidget {
  static String route = 'convert_dialog_view';
  final bool isName;

  ConvertDialogView({super.key, required this.isName});

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    TextTheme textTheme = Theme.of(context).textTheme;

    if (isName) {
      return AlertDialog(
        icon: Icon(Icons.change_circle),
        title: Text('Convert?'),
        content: ListTile(
          leading: Icon(Icons.image),
          title: Text('Name'),
          subtitle: Text('010-0000-0000'),
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
              Navigator.pushNamed(context, CallChatView.route);
            },
            child: Text('Convert'),
          ),
        ],
      );
    } else {
      return AlertDialog(
        icon: Icon(Icons.change_circle),
        title: Text('Convert?'),
        content: ListTile(
          leading: Icon(Icons.image),
          title: Text('010-0000-0000'),
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
              Navigator.pushNamed(context, CallChatView.route);
            },
            child: Text('Convert'),
          ),
        ],
      );
    }
  }
}
