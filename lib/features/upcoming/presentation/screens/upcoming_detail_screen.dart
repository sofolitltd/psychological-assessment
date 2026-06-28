import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/design_system/app_theme.dart';
import '../../../../core/design_system/responsive.dart';
import '../../../../core/widgets/mobile_bottom_nav.dart';
import '../../../../core/widgets/web_top_nav.dart';
import '../../../../features/assessment/presentation/widgets/detail_content_card.dart';
import '../../../../features/assessment/presentation/widgets/detail_lucide_icon_map.dart';
import '../../../../features/assessment/presentation/widgets/detail_top_bar.dart';
import '../../../assessment/domain/assessment_models.dart';
import '../../../assessment/presentation/widgets/detail_stats.dart';
import '../../data/upcoming_repository.dart';
import '../dialogs/upcoming_contact_dialog.dart';
import '../widgets/upcoming_test_model.dart';

class UpcomingDetailScreen extends ConsumerWidget {
  final String testId;
  const UpcomingDetailScreen({super.key, required this.testId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textTheme = Theme.of(context).textTheme;
    final isMobile = Responsive.isMobile(context);
    final maxWidth = Responsive.maxContentWidth(context);
    final notoSerif = GoogleFonts.notoSerifBengali();

    final listAsync = ref.watch(upcomingTestListProvider);

    return Title(
      title: 'Upcoming - Psychological Assessment',
      color: AppColors.primary,
      child: Scaffold(
        body: Column(
          children: [
            if (!isMobile) const WebTopNav(currentTab: 'upcoming'),
            Expanded(
              child: listAsync.when(
                error: (error, _) => Center(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: Text(
                      'Something went wrong.\n$error',
                      textAlign: TextAlign.center,
                      style: textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ),
                ),
                loading: () => const SizedBox.shrink(),
                data: (items) {
                  final item = items.where((t) => t.test.id == testId).firstOrNull;
                  if (item == null) {
                    return Center(
                      child: Text(
                        'Test not found',
                        style: textTheme.bodyMedium,
                      ),
                    );
                  }

                  final test = item.test;
                  final icon = lucideIconMap[test.lucideIconName] ?? LucideIcons.clipboardList;
                  final color = test.themeColor;

                  final topBar = DetailTopBar(
                    isMobile: isMobile,
                    testName: test.name,
                    breadcrumbLabel: 'Upcoming',
                    breadcrumbRoute: '/upcoming',
                  );

                  final contentSlivers = <Widget>[
                    SliverToBoxAdapter(
                      child: DetailContentCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: color.withValues(alpha: 0.12),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(icon, size: 24, color: color),
                                ),
                                const SizedBox(width: AppSpacing.md),
                                Flexible(
                                  child: Text(
                                    test.name,
                                    style: GoogleFonts.outfit(
                                      height: 1.2,
                                      fontSize: Responsive.isDesktop(context)
                                          ? 26
                                          : Responsive.isTablet(context)
                                              ? 22
                                              : 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            if (test.description.isNotEmpty) ...[
                              const SizedBox(height: AppSpacing.md),
                              Divider(),
                              const SizedBox(height: AppSpacing.md),
                              Text(
                                test.description,
                                style: TextStyle(
                                  fontFamily: notoSerif.fontFamily,
                                  fontSize: 15,
                                  height: 1.7,
                                  color: isDark
                                      ? AppColors.textSecondaryDark
                                      : AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: _buildStats(item, isDark, textTheme, isMobile),
                    ),
                    if (item.resources.banglaVersionUrl.isNotEmpty || item.resources.banglaVersionScoringUrl.isNotEmpty)
                      SliverToBoxAdapter(
                        child: _buildResources(item, test, isDark, textTheme, context),
                      ),
                    SliverToBoxAdapter(
                      child: _buildEarlyAccess(isDark, textTheme, context),
                    ),
                  ];

                  if (isMobile) {
                    return Center(
                      child: Container(
                        constraints: BoxConstraints(maxWidth: maxWidth),
                        child: Column(
                          children: [
                            topBar,
                            Expanded(
                              child: CustomScrollView(
                                slivers: [
                                  ...contentSlivers,
                                  const SliverToBoxAdapter(
                                    child: SizedBox(height: AppSpacing.xl),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  return Center(
                    child: Container(
                      constraints: BoxConstraints(maxWidth: maxWidth),
                      child: Column(
                        children: [
                          topBar,
                          Expanded(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: Responsive.isDesktop(context) ? 2 : 3,
                                  child: CustomScrollView(
                                    slivers: [
                                      ...contentSlivers,
                                      const SliverToBoxAdapter(
                                        child: SizedBox(height: AppSpacing.xl),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            if (isMobile) const MobileBottomNav(currentTab: 'upcoming'),
          ],
        ),
      ),
    );
  }

  Widget _buildStats(UpcomingTestItem item, bool isDark, TextTheme textTheme, bool isMobile) {
    final test = item.test;
    final cards = <Widget>[
      DetailStatCard(
        icon: LucideIcons.helpCircle,
        title: 'Total Items',
        value: '${test.questionCount}',
        isDark: isDark,
        textTheme: textTheme,
      ),
      DetailStatCard(
        icon: LucideIcons.clock,
        title: 'Total Time',
        value: test.estimatedTimeMinutes > 0
            ? '${test.estimatedTimeMinutes} min'
            : '—',
        isDark: isDark,
        textTheme: textTheme,
      ),
      DetailStatCard(
        icon: LucideIcons.activity,
        title: 'Sensitivity',
        value: test.sensitivityLevel.isNotEmpty
            ? test.sensitivityLevel
            : '—',
        isDark: isDark,
        textTheme: textTheme,
      ),
      DetailStatCard(
        icon: LucideIcons.folder,
        title: 'Category',
        value: test.category,
        isDark: isDark,
        textTheme: textTheme,
      ),
      DetailStatCard(
        icon: LucideIcons.shieldCheck,
        title: 'Reliability',
        value: test.reliabilityBadge.isNotEmpty
            ? test.reliabilityBadge
            : '—',
        isDark: isDark,
        textTheme: textTheme,
      ),
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.md, AppSpacing.md, 0),
      child: !isMobile
          ? Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: cards,
            )
          : SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: cards
                    .map(
                      (c) => Padding(
                        padding: const EdgeInsets.only(right: AppSpacing.sm),
                        child: SizedBox(width: 145, child: c),
                      ),
                    )
                    .toList(),
              ),
            ),
    );
  }

  Widget _buildResources(
    UpcomingTestItem item,
    TestListItem test,
    bool isDark,
    TextTheme textTheme,
    BuildContext context,
  ) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.md, AppSpacing.md, 0),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceDark : AppColors.surface,
          borderRadius: AppRadius.roundedMd,
          border: Border.all(
            color: isDark ? AppColors.borderDark : AppColors.border,
            width: 0.5,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  LucideIcons.bookOpen,
                  size: 16,
                  color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                ),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  'রিসোর্স',
                  style: GoogleFonts.notoSerifBengali(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: [
                if (item.resources.banglaVersionUrl.isNotEmpty)
                  OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      side: BorderSide(
                        color: isDark ? AppColors.borderDark : AppColors.border,
                        width: 0.5,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: AppRadius.roundedMd,
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                        vertical: 12,
                      ),
                    ),
                    onPressed: () => context.push('/upcoming/${test.id}/pdf-viewer?url=${Uri.encodeComponent(item.resources.banglaVersionUrl)}&title=${Uri.encodeComponent(test.name)}'),
                    icon: const Icon(LucideIcons.fileText, size: 18),
                    label: Text(
                      'মূল পিডিএফ',
                      style: GoogleFonts.notoSerifBengali(fontSize: 13),
                    ),
                  ),
                if (item.resources.banglaVersionScoringUrl.isNotEmpty)
                  OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      side: BorderSide(
                        color: isDark ? AppColors.borderDark : AppColors.border,
                        width: 0.5,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: AppRadius.roundedMd,
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                        vertical: 12,
                      ),
                    ),
                    onPressed: () => context.push('/upcoming/${test.id}/pdf-viewer?url=${Uri.encodeComponent(item.resources.banglaVersionScoringUrl)}&title=${Uri.encodeComponent('${test.name} - Scoring')}'),
                    icon: const Icon(LucideIcons.fileCheck, size: 18),
                    label: Text(
                      'স্কোরিং গাইড',
                      style: GoogleFonts.notoSerifBengali(fontSize: 13),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEarlyAccess(
    bool isDark,
    TextTheme textTheme,
    BuildContext context,
  ) {
    final isDesktop = Responsive.isDesktop(context);
    final notoSerifFont = GoogleFonts.notoSerifBengali();

    if (isDesktop) {
      return GestureDetector(
        onTap: () => showUpcomingContactDialog(context, isDark, textTheme),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.md, AppSpacing.md, 0),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
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
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(LucideIcons.handshake, color: Colors.white, size: 28),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'আর্লি অ্যাক্সেসের জন্য অনুরোধ করুন',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontFamily: notoSerifFont.fontFamily,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'বাংলা মানসিক মূল্যায়ন টুল তৈরিতে আমাদের সাথে অংশ নিন',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white.withValues(alpha: 0.85),
                          fontFamily: notoSerifFont.fontFamily,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  LucideIcons.chevronRight,
                  size: 24,
                  color: Colors.white.withValues(alpha: 0.7),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.md, AppSpacing.md, 0),
      child: SizedBox(
        width: double.infinity,
        child: FilledButton.icon(
          onPressed: () => showUpcomingContactDialog(context, isDark, textTheme),
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
    );
  }
}
