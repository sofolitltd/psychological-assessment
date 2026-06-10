import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/design_system/app_theme.dart';
import '../data/assessment_repository.dart';
import 'assessment_results_screen.dart';

class ResultScreenLoader extends ConsumerWidget {
  final String testId;
  const ResultScreenLoader({super.key, required this.testId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bundle = ref.watch(resultBundleProvider)[testId];
    if (bundle == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                LucideIcons.fileQuestion,
                size: 64,
                color: AppColors.textSecondary.withValues(alpha: 0.5),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                'কোনো ফলাফল পাওয়া যায়নি',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontFamily: GoogleFonts.notoSerifBengali().fontFamily,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'পরীক্ষাটি সম্পূর্ণ করে ফলাফল দেখুন',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                  fontFamily: GoogleFonts.notoSerifBengali().fontFamily,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xl),
              OutlinedButton.icon(
                onPressed: () => context.go('/'),
                icon: const Icon(LucideIcons.arrowLeft, size: 18),
                label: Text(
                  'ফিরে যান',
                  style: GoogleFonts.notoSerifBengali(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                    vertical: AppSpacing.md,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: AppRadius.roundedMd,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
    return AssessmentResultsScreen(bundle: bundle);
  }
}
