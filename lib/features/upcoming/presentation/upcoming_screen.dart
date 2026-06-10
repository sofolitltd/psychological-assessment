import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/design_system/app_theme.dart';
import '../../../core/design_system/responsive.dart';
import '../../assessment/presentation/widgets/mobile_bottom_nav.dart';
import '../../assessment/presentation/widgets/web_top_nav.dart';

class UpcomingScreen extends ConsumerWidget {
  const UpcomingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isMobile = Responsive.isMobile(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textTheme = Theme.of(context).textTheme;

    final upcomingTests = [
      _UpcomingTest(
        name: 'Pittsburgh Sleep Quality Index',
        subtitle: 'PSQI',
        description: 'Sleep quality assessment over the past month.',
        eta: 'Q3 2026',
        icon: LucideIcons.moon,
      ),
      _UpcomingTest(
        name: 'DU Anxiety Scale',
        subtitle: 'Dhaka University Anxiety Scale',
        description: 'Anxiety symptom severity assessment.',
        eta: 'Q3 2026',
        icon: LucideIcons.brain,
      ),
      _UpcomingTest(
        name: 'DU Depression Scale',
        subtitle: 'Dhaka University Depression Scale',
        description: 'Depression symptom severity assessment.',
        eta: 'Q3 2026',
        icon: LucideIcons.heart,
      ),
      _UpcomingTest(
        name: 'GHQ 28 Questionnaire',
        subtitle: 'General Health Questionnaire',
        description: 'General psychological well-being assessment.',
        eta: 'Q3 2026',
        icon: LucideIcons.scrollText,
      ),
      _UpcomingTest(
        name: 'Hospital Anxiety & Depression Scale',
        subtitle: 'HADS',
        description: 'Anxiety and depression screening for hospital patients.',
        eta: 'Q4 2026',
        icon: LucideIcons.heartPulse,
      ),
      _UpcomingTest(
        name: 'Social Interaction Anxiety Scale',
        subtitle: 'SIAS (20 items)',
        description: 'Social interaction anxiety assessment.',
        eta: 'Q4 2026',
        icon: LucideIcons.users,
      ),
      _UpcomingTest(
        name: 'Somatic Complaints Scale',
        subtitle: '24 items',
        description: 'Physical symptom and somatic complaint assessment.',
        eta: 'Q4 2026',
        icon: LucideIcons.activity,
      ),
      _UpcomingTest(
        name: 'Cognitive Distortion Scale',
        subtitle: '39 items',
        description: 'Cognitive distortion and thinking pattern assessment.',
        eta: 'Q4 2026',
        icon: LucideIcons.brain,
      ),
      _UpcomingTest(
        name: 'Cognitive Emotion Regulation Questionnaire',
        subtitle: 'CERQ Bangla (Revised 2016)',
        description: 'Cognitive emotion regulation strategies assessment.',
        eta: 'Q4 2026',
        icon: LucideIcons.bookOpen,
      ),
    ];

    return Title(
      title: 'Upcoming - Psychological Assessment',
      color: AppColors.primary,
      child: Scaffold(
      body: Column(
        children: [
          if (!isMobile)
            const WebTopNav(currentTab: 'upcoming'),
          Expanded(
            child: Center(
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: Responsive.maxContentWidth(context),
                ),
                padding: EdgeInsets.all(
                  isMobile ? AppSpacing.md : AppSpacing.lg,
                ),
                child: CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Upcoming Tests',
                            style: textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            'New assessments currently in development.',
                            style: textTheme.bodyMedium?.copyWith(
                              color: isDark
                                  ? AppColors.textSecondaryDark
                                  : AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.lg),

                          GestureDetector(
                            onTap: () => _showContactDialog(context, isDark, textTheme),
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 14),
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
                                          'আমাদের সাথে যোগ দিন ',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                            fontFamily: GoogleFonts.notoSerifBengali().fontFamily,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          ' আপনার সংগ্রহের টেস্ট শেয়ার করে এই প্রচেষ্টাকে সমৃদ্ধ করুন ।',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.white.withValues(alpha: 0.85),
                                            fontFamily: GoogleFonts.notoSerifBengali().fontFamily,
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
                          ),

                          const SizedBox(height: AppSpacing.lg),

                          for (final test in upcomingTests) ...[
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(AppSpacing.md),
                              decoration: BoxDecoration(
                                color: isDark
                                    ? AppColors.surfaceDark
                                    : AppColors.surface,
                                borderRadius: AppRadius.roundedMd,
                                border: Border.all(
                                  color: isDark
                                      ? AppColors.borderDark
                                      : AppColors.border,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: AppColors.primary
                                          .withValues(alpha: 0.1),
                                      borderRadius:
                                          BorderRadius.circular(12),
                                    ),
                                    child: Icon(
                                      test.icon,
                                      color: AppColors.primary,
                                      size: 24,
                                    ),
                                  ),
                                  const SizedBox(width: AppSpacing.md),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          test.name,
                                          style:
                                              textTheme.titleMedium?.copyWith(
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Text(
                                          test.subtitle,
                                          style: textTheme.bodySmall
                                              ?.copyWith(
                                            color: isDark
                                                ? AppColors
                                                    .textSecondaryDark
                                                : AppColors.textSecondary,
                                          ),
                                        ),
                                        const SizedBox(
                                            height: AppSpacing.xs),
                                        Text(
                                          test.description,
                                          style: textTheme.bodySmall,
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: AppSpacing.md),
                                  Container(
                                    padding:
                                        const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.primary
                                          .withValues(alpha: 0.1),
                                      borderRadius:
                                          BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      test.eta,
                                      style: textTheme.labelSmall?.copyWith(
                                        color: AppColors.primary,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: AppSpacing.sm),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (isMobile)
            const MobileBottomNav(currentTab: 'upcoming'),
        ],
      ),
      ),
    );
  }
}

void _showContactDialog(BuildContext context, bool isDark, TextTheme textTheme) {
  final notoSerif = GoogleFonts.notoSerifBengali();
  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: AppRadius.roundedMd),
      title: Row(
        children: [
          const Icon(LucideIcons.handshake, color: AppColors.primary, size: 22),
          const SizedBox(width: 10),
          Expanded(child: Text('যোগ দিন', style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, fontFamily: notoSerif.fontFamily))),
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
            'বাংলা মনস্তাত্ত্বিক মূল্যায়ন টুল তৈরিতে আমাদের সাথে অংশ নিতে নিচের যেকোনো মাধ্যমে যোগাযোগ করুন।',
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

class _UpcomingTest {
  final String name;
  final String subtitle;
  final String description;
  final String eta;
  final IconData icon;

  const _UpcomingTest({
    required this.name,
    required this.subtitle,
    required this.description,
    required this.eta,
    required this.icon,
  });
}
