import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'package:psychological_assessment/core/design_system/app_theme.dart';
import 'package:psychological_assessment/features/assessment/domain/pdf_info_models.dart';

class PdfReportTypePicker extends StatelessWidget {
  final PdfType selectedType;
  final ValueChanged<PdfType> onChanged;

  const PdfReportTypePicker({
    super.key,
    required this.selectedType,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select report type:',
          style: GoogleFonts.outfit(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Align(
          alignment: Alignment.centerLeft,
          child: SegmentedButton<PdfType>(
            segments: [
              ButtonSegment(
                value: PdfType.full,
                label: Text('সম্পূর্ণ',
                  style: TextStyle(
                    fontFamily: GoogleFonts.notoSerifBengali().fontFamily,
                    fontSize: 14,
                  ),
                ),
                icon: const Icon(LucideIcons.fileText, size: 18),
              ),
              ButtonSegment(
                value: PdfType.summary,
                label: Text('সংক্ষিপ্ত',
                  style: TextStyle(
                    fontFamily: GoogleFonts.notoSerifBengali().fontFamily,
                    fontSize: 14,
                  ),
                ),
                icon: const Icon(LucideIcons.fileMinus, size: 18),
              ),
            ],
            selected: {selectedType},
            onSelectionChanged: (selection) => onChanged(selection.first),
            style: ButtonStyle(
              visualDensity: VisualDensity.compact,
              backgroundColor:
                  WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return AppColors.primary.withValues(alpha: 0.15);
                }
                return null;
              }),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          selectedType == PdfType.full
              ? 'ক্লায়েন্ট তথ্য, মূল্যায়ন, স্কোর, বিস্তারিত ব্যাখ্যা ও সতর্কতা'
              : 'ক্লায়েন্ট তথ্য, মূল্যায়ন, স্কোর ও সতর্কতা (ব্যাখ্যা ছাড়া)',
          style: TextStyle(
            fontSize: 12,
            color: isDark
                ? AppColors.textSecondaryDark
                : AppColors.textSecondary,
            fontFamily: GoogleFonts.notoSerifBengali().fontFamily,
          ),
        ),
      ],
    );
  }
}
