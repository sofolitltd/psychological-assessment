import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:psychological_assessment/core/design_system/app_theme.dart';

class DialogActionBar extends StatelessWidget {
  final String cancelLabel;
  final String actionLabel;
  final VoidCallback onCancel;
  final VoidCallback onAction;
  final IconData actionIcon;
  final bool isActionDisabled;

  const DialogActionBar({
    super.key,
    required this.cancelLabel,
    required this.actionLabel,
    required this.onCancel,
    required this.onAction,
    required this.actionIcon,
    this.isActionDisabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        0,
        AppSpacing.md,
        AppSpacing.md,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(
            onPressed: onCancel,
            child: Text(
              cancelLabel,
              style: TextStyle(
                fontFamily: GoogleFonts.notoSerifBengali().fontFamily,
              ),
            ),
          ),
          const SizedBox(width: 8),
          FilledButton.icon(
            icon: Icon(actionIcon, size: 18),
            label: Text(
              actionLabel,
              style: TextStyle(
                fontFamily: GoogleFonts.notoSerifBengali().fontFamily,
              ),
            ),
            onPressed: isActionDisabled ? null : onAction,
          ),
        ],
      ),
    );
  }
}
