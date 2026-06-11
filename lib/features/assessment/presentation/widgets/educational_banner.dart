import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'package:psychological_assessment/core/design_system/app_theme.dart';

class EducationalBanner extends StatelessWidget {
  final VoidCallback onDismiss;
  final VoidCallback onContactTap;

  const EducationalBanner({
    super.key,
    required this.onDismiss,
    required this.onContactTap,
  });

  @override
  Widget build(BuildContext context) {
    final notoSerif = GoogleFonts.notoSerifBengali();

    return GestureDetector(
      onTap: onContactTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: 4),
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.orange.withValues(alpha: 0.6),
                  Colors.orange.withValues(alpha: 0.9),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: AppRadius.roundedSm,
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Text(
              'এটি একটি শিক্ষামূলক প্রকল্প। শিক্ষক, শিক্ষার্থী এবং কমিউনিটির কাছ থেকে তথ্য সংগ্রহ করা হয়েছে। দয়া করে দায়িত্বশীলভাবে ব্যবহার করুন। যে কোন প্রশ্ন বা মতামত জানাতে এখানে ক্লিক করুন।',
              style: TextStyle(
                fontSize: 12,
                color: Colors.white.withValues(alpha: 0.85),
                fontFamily: notoSerif.fontFamily,
              ),
            ),
          ),
          Positioned(
            top: -5,
            right: -5,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: onDismiss,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.9),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  LucideIcons.x,
                  size: 14,
                  color: Colors.orange.withValues(alpha: 0.9),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
