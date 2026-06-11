import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../../core/design_system/app_theme.dart';
import 'upcoming_contact_dialog.dart';

class UpcomingJoinBanner extends StatelessWidget {
  final bool isDark;
  final TextTheme textTheme;

  const UpcomingJoinBanner({super.key, required this.isDark, required this.textTheme});

  @override
  Widget build(BuildContext context) {
    final notoSerif = GoogleFonts.notoSerifBengali();

    return GestureDetector(
      onTap: () => showUpcomingContactDialog(context, isDark, textTheme),
      child: Container(
        width: double.infinity,
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
          borderRadius: AppRadius.roundedMd,
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.3),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(LucideIcons.handshake, color: Colors.white, size: 20),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'আমাদের সাথে যোগ দিন',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontFamily: notoSerif.fontFamily,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    ' আপনার সংগ্রহের টেস্ট শেয়ার করে এই প্রচেষ্টাকে সমৃদ্ধ করুন ।',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white.withValues(alpha: 0.85),
                      fontFamily: notoSerif.fontFamily,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              LucideIcons.chevronRight,
              size: 18,
              color: Colors.white.withValues(alpha: 0.7),
            ),
          ],
        ),
      ),
    );
  }
}
