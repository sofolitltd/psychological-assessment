import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/design_system/app_theme.dart';
import '../../domain/auth_providers.dart';

Future<bool> showLoginDialog(BuildContext context, WidgetRef ref) async {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  final notoSerif = GoogleFonts.notoSerifBengali();
  final result = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surface,
      shape: RoundedRectangleBorder(borderRadius: AppRadius.roundedMd),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(LucideIcons.logIn, size: 48, color: AppColors.primary),
          const SizedBox(height: AppSpacing.md),
          Text(
            'লগইন প্রয়োজন',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: notoSerif.fontFamily,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'এই ফিচার ব্যবহার করতে আপনার অ্যাকাউন্টে লগইন করুন।',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              fontFamily: notoSerif.fontFamily,
              color: isDark
                  ? AppColors.textSecondaryDark
                  : AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton.icon(
              icon: const Icon(LucideIcons.logIn, size: 20),
              label: Text('Google দিয়ে লগইন করুন',
                  style: TextStyle(fontFamily: notoSerif.fontFamily)),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: AppRadius.roundedSm),
              ),
              onPressed: () async {
                try {
                  await ref.read(authServiceProvider).signInWithGoogle();
                  if (ctx.mounted) Navigator.of(ctx).pop(true);
                } catch (e) {
                  if (ctx.mounted) {
                    ScaffoldMessenger.of(ctx).showSnackBar(
                      SnackBar(content: Text('লগইন ব্যর্থ: $e')),
                    );
                  }
                }
              },
            ),
          ),
        ],
      ),
    ),
  );
  return result ?? false;
}
