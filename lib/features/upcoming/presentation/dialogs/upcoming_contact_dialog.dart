import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:psychological_assessment/core/design_system/app_theme.dart';

void showUpcomingContactDialog(
  BuildContext context,
  bool isDark,
  TextTheme textTheme, {
  String? titleText,
  String? subtitleText,
}) {
  final notoSerif = GoogleFonts.notoSerifBengali();
  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: AppRadius.roundedMd),
      backgroundColor: isDark ? AppColors.surfaceDark : Colors.white,
      title: Row(
        children: [
          const Icon(LucideIcons.handshake, color: AppColors.primary, size: 22),
          const SizedBox(width: 10),
          Expanded(child: Text(
            titleText ?? 'যোগ দিন',
            style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, fontFamily: notoSerif.fontFamily),
          )),
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
          Text(
            subtitleText ?? 'বাংলা মনস্তাত্ত্বিক মূল্যায়ন টুল তৈরিতে আমাদের সাথে অংশ নিতে নিচের যেকোনো মাধ্যমে যোগাযোগ করুন।',
            style: textTheme.bodyMedium?.copyWith(height: 1.5, fontFamily: notoSerif.fontFamily),
          ),
          const SizedBox(height: AppSpacing.lg),
          _ContactRow(
            icon: LucideIcons.messageSquare,
            label: 'Facebook',
            value: '/asifuzzamanreyad',
            url: 'https://www.facebook.com/asifuzzamanreyad',
            textTheme: textTheme,
          ),
          const SizedBox(height: AppSpacing.sm),
          _ContactRow(
            icon: LucideIcons.messageCircle,
            label: 'WhatsApp',
            value: '+880 1704-340860',
            url: 'https://wa.me/+8801704340860',
            textTheme: textTheme,
          ),
          const SizedBox(height: AppSpacing.sm),
          _ContactRow(
            icon: LucideIcons.briefcase,
            label: 'LinkedIn',
            value: '/in/asifuzzamanreyad',
            url: 'https://linkedin.com/in/asifuzzamanreyad',
            textTheme: textTheme,
          ),
          const SizedBox(height: AppSpacing.sm),
          _ContactRow(
            icon: LucideIcons.playCircle,
            label: 'YouTube',
            value: '@sofolitltd',
            url: 'https://youtube.com/@sofolitltd',
            textTheme: textTheme,
          ),
        ],
      ),
    ),
  );
}

class _ContactRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final String url;
  final TextTheme textTheme;

  const _ContactRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.url,
    required this.textTheme,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => launchUrl(Uri.parse(url)),
      borderRadius: AppRadius.roundedSm,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        child: Row(
          children: [
            Icon(icon, size: 18, color: AppColors.primary),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: textTheme.bodySmall?.copyWith(color: AppColors.textSecondary)),
                  Text(value, style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
