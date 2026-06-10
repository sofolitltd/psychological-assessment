import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/design_system/app_theme.dart';

class RunnerSubmitButton extends StatelessWidget {
  final bool isComplete;
  final VoidCallback? onSubmit;

  const RunnerSubmitButton({
    super.key,
    required this.isComplete,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.sm, bottom: AppSpacing.lg),
      child: SizedBox(
        width: double.infinity,
        height: 48,
        child: ElevatedButton.icon(
          onPressed: isComplete ? onSubmit : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: AppRadius.roundedSm,
            ),
          ),
          icon: const Icon(LucideIcons.arrowRight, size: 18),
          label: Text(
            'মূল্যায়ন জমা দিন',
            style: GoogleFonts.notoSerifBengali(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
