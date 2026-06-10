import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/design_system/app_theme.dart';
import '../../../core/design_system/responsive.dart';
import '../data/assessment_repository.dart';
import 'widgets/detail_about_section.dart';
import 'widgets/detail_content_card.dart';
import 'widgets/detail_header_card.dart';
import 'widgets/detail_instruction_section.dart';
import 'widgets/detail_lucide_icon_map.dart';
import 'widgets/detail_ready_card.dart';
import 'widgets/detail_resources_card.dart';
import 'widgets/detail_stats.dart';
import 'widgets/detail_top_bar.dart';
import 'widgets/mobile_bottom_nav.dart';
import 'widgets/web_top_nav.dart';

class TestDetailScreen extends ConsumerWidget {
  final String testId;
  const TestDetailScreen({super.key, required this.testId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textTheme = Theme.of(context).textTheme;
    final isMobile = Responsive.isMobile(context);
    final maxWidth = Responsive.maxContentWidth(context);

    final testAsync = ref.watch(testDetailProvider(testId));
    final listAsync = ref.watch(testListProvider);

    return Scaffold(
      body: Column(
        children: [
          if (!isMobile) const WebTopNav(currentTab: 'tests'),
          Expanded(
            child: testAsync.when(
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
              data: (test) {
                final meta = listAsync.whenOrNull(
                  data: (list) =>
                      list.where((t) => t.id == testId).firstOrNull,
                );

                final titleColor = meta?.themeColor ?? AppColors.primary;
                final titleIcon =
                    lucideIconMap[meta?.lucideIconName ?? ''] ??
                    LucideIcons.clipboardList;

                final contentSlivers = <Widget>[
                  SliverToBoxAdapter(child: DetailHeaderCard(
                    test: test,
                    titleIcon: titleIcon,
                    titleColor: titleColor,
                  )),
                  if (test.about != null && test.about!.isNotEmpty)
                    SliverToBoxAdapter(
                      child: DetailContentCard(
                        child: DetailAboutSection(
                          text: test.about!,
                          isDark: isDark,
                          textTheme: textTheme,
                        ),
                      ),
                    ),
                  SliverToBoxAdapter(
                    child: DetailStatsRow(
                      test: test,
                      meta: meta,
                      isDark: isDark,
                      textTheme: textTheme,
                    ),
                  ),
                  if (test.instruction != null && test.instruction!.isNotEmpty)
                    SliverToBoxAdapter(
                      child: DetailContentCard(
                        child: DetailInstructionSection(
                          text: test.instruction!,
                          isDark: isDark,
                          textTheme: textTheme,
                        ),
                      ),
                    ),
                ];

                final topBar = DetailTopBar(
                  isMobile: isMobile,
                  testName: test.testName,
                );

                if (isMobile) {
                  return Title(
                    title: '${test.testName} - Psychological Assessment',
                    color: AppColors.primary,
                    child: Center(
                      child: Container(
                        constraints: BoxConstraints(maxWidth: maxWidth),
                        child: Column(
                          children: [
                            topBar,
                            Expanded(
                              child: CustomScrollView(
                                slivers: [
                                  ...contentSlivers,
                                  SliverToBoxAdapter(
                                    child: DetailResourcesCard(
                                      test: test,
                                      isDark: isDark,
                                      outerContext: context,
                                    ),
                                  ),
                                  SliverToBoxAdapter(
                                    child: DetailReadyCard(
                                      test: test,
                                      meta: meta,
                                    ),
                                  ),
                                  const SliverToBoxAdapter(
                                    child: SizedBox(height: AppSpacing.xl),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }

                return Title(
                  title: '${test.testName} - Psychological Assessment',
                  color: AppColors.primary,
                  child: Center(
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
                              SizedBox(
                                width: Responsive.isDesktop(context) ? 24 : 8,
                              ),
                              Expanded(
                                flex: Responsive.isDesktop(context) ? 1 : 2,
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    DetailResourcesCard(
                                      test: test,
                                      isDark: isDark,
                                      outerContext: context,
                                    ),
                                    const SizedBox(height: AppSpacing.md),
                                    DetailReadyCard(test: test, meta: meta),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ));
              },
            ),
          ),
          if (isMobile) const MobileBottomNav(currentTab: 'tests'),
        ],
      ),
    );
  }
}
