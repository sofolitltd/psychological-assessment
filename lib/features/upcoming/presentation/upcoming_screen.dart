import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/design_system/app_theme.dart';
import '../../../core/design_system/responsive.dart';
import '../../assessment/presentation/widgets/mobile_bottom_nav.dart';
import '../../assessment/presentation/widgets/web_top_nav.dart';
import 'widgets/upcoming_join_banner.dart';
import 'widgets/upcoming_test_card.dart';
import 'widgets/upcoming_test_model.dart';

class UpcomingScreen extends ConsumerWidget {
  const UpcomingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isMobile = Responsive.isMobile(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textTheme = Theme.of(context).textTheme;

    final upcomingTests = [
      UpcomingTest(name: 'Pittsburgh Sleep Quality Index', subtitle: 'PSQI', description: 'Sleep quality assessment over the past month.', eta: 'Q3 2026', icon: LucideIcons.moon),
      UpcomingTest(name: 'DU Anxiety Scale', subtitle: 'Dhaka University Anxiety Scale', description: 'Anxiety symptom severity assessment.', eta: 'Q3 2026', icon: LucideIcons.brain),
      UpcomingTest(name: 'DU Depression Scale', subtitle: 'Dhaka University Depression Scale', description: 'Depression symptom severity assessment.', eta: 'Q3 2026', icon: LucideIcons.heart),
      UpcomingTest(name: 'GHQ 28 Questionnaire', subtitle: 'General Health Questionnaire', description: 'General psychological well-being assessment.', eta: 'Q3 2026', icon: LucideIcons.scrollText),
      UpcomingTest(name: 'Hospital Anxiety & Depression Scale', subtitle: 'HADS', description: 'Anxiety and depression screening for hospital patients.', eta: 'Q4 2026', icon: LucideIcons.heartPulse),
      UpcomingTest(name: 'Social Interaction Anxiety Scale', subtitle: 'SIAS (20 items)', description: 'Social interaction anxiety assessment.', eta: 'Q4 2026', icon: LucideIcons.users),
      UpcomingTest(name: 'Somatic Complaints Scale', subtitle: '24 items', description: 'Physical symptom and somatic complaint assessment.', eta: 'Q4 2026', icon: LucideIcons.activity),
      UpcomingTest(name: 'Cognitive Distortion Scale', subtitle: '39 items', description: 'Cognitive distortion and thinking pattern assessment.', eta: 'Q4 2026', icon: LucideIcons.brain),
      UpcomingTest(name: 'Cognitive Emotion Regulation Questionnaire', subtitle: 'CERQ Bangla (Revised 2016)', description: 'Cognitive emotion regulation strategies assessment.', eta: 'Q4 2026', icon: LucideIcons.bookOpen),
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
                          Text('Upcoming Tests', style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
                          const SizedBox(height: AppSpacing.xs),
                          Text('New assessments currently in development.', style: textTheme.bodyMedium?.copyWith(
                            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                          )),
                          const SizedBox(height: AppSpacing.lg),
                          UpcomingJoinBanner(isDark: isDark, textTheme: textTheme),
                          const SizedBox(height: AppSpacing.lg),
                          for (final test in upcomingTests) ...[
                            UpcomingTestCard(test: test, isDark: isDark, textTheme: textTheme),
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
