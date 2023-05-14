import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_voice/model/setting_model.dart';

class EmergencyContactDialogView extends StatelessWidget {
  const EmergencyContactDialogView({super.key});

  @override
  Widget build(BuildContext context) {
    ColorScheme cs = Theme.of(context).colorScheme;
    TextTheme tt = Theme.of(context).textTheme;
    String emergencyContact = '';

    return Consumer<SettingModel>(
      builder: (_, value, __) {
        final bool lang = value.language == Language.english;

        return AlertDialog(
          icon: const Icon(Icons.report),
          title: Text(lang ? 'Emergency Contact' : '비상 연락처'),
          content: TextField(
            onChanged: (value) => emergencyContact = value,
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
              onPressed: () {
                value.changeEmergencyContact(emergencyContact);
                Navigator.pop(context);
              },
              child: Text(lang ? 'Enroll' : '등록'),
            ),
          ],
        );
      },
    );
  }
}
