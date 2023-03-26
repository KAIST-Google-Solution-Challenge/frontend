import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_voice/model/setting_model.dart';

class EmergencyContactDialogView extends StatelessWidget {
  const EmergencyContactDialogView({super.key});

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    TextTheme textTheme = Theme.of(context).textTheme;
    String emergencyContact = '';

    return Consumer<SettingModel>(
      builder: (context, value, child) => AlertDialog(
        icon: const Icon(Icons.report),
        title: Text(
          value.language == Language.english ? 'Emergency Contact' : '비상 연락처',
        ),
        content: TextField(
          onChanged: (value) => emergencyContact = value,
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
              value.changeEmergencyContact(
                emergencyContact,
              );

              Navigator.pop(context);
            },
            child: Text(
              value.language == Language.english ? 'Enroll' : '등록',
            ),
          ),
        ],
      ),
    );
  }
}
