import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:psychological_assessment/core/design_system/app_theme.dart';
import 'package:psychological_assessment/features/assessment/presentation/widgets/detail_lucide_icon_map.dart';
import '../dialogs/upcoming_contact_dialog.dart';
import '../widgets/upcoming_test_model.dart';

void showUpcomingResourceDialog(
  BuildContext context,
  UpcomingTestItem item,
  bool isDark,
  TextTheme textTheme,
) {
  final notoSerif = GoogleFonts.notoSerifBengali();
  final test = item.test;
  final icon = lucideIconMap[test.lucideIconName] ?? LucideIcons.clipboardList;

  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: AppRadius.roundedMd),
      title: Row(
        crossAxisAlignment: .start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: test.themeColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 20, color: test.themeColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              test.name,
              style: textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                fontFamily: GoogleFonts.outfit().fontFamily,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(LucideIcons.x, size: 20),
            onPressed: () => Navigator.of(ctx).pop(),
            splashRadius: 20,
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (test.description.isNotEmpty) ...[
            Text(
              test.description,
              style: textTheme.bodyMedium?.copyWith(
                height: 1.5,
                fontFamily: notoSerif.fontFamily,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
          ],
          if (item.resources.banglaVersionUrl.isNotEmpty) ...[
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => launchUrl(Uri.parse(item.resources.banglaVersionUrl)),
                icon: const Icon(LucideIcons.fileText, size: 18),
                label: Text(
                  'পিডিএফ ডাউনলোড করুন',
                  style: GoogleFonts.notoSerifBengali(fontSize: 14),
                ),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: AppRadius.roundedSm,
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
          ],
          if (item.resources.banglaVersionScoringUrl.isNotEmpty) ...[
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => launchUrl(Uri.parse(item.resources.banglaVersionScoringUrl)),
                icon: const Icon(LucideIcons.bookOpen, size: 18),
                label: Text(
                  'স্কোরিং গাইড ডাউনলোড করুন',
                  style: GoogleFonts.notoSerifBengali(fontSize: 14),
                ),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: AppRadius.roundedSm,
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
          ],
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: () {
                Navigator.of(ctx).pop();
                showUpcomingContactDialog(context, isDark, textTheme);
              },
              icon: const Icon(LucideIcons.handshake, size: 18),
              label: Text(
                'আর্লি অ্যাক্সেসের জন্য অনুরোধ করুন',
                style: GoogleFonts.notoSerifBengali(fontSize: 14),
              ),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: AppRadius.roundedSm,
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}


