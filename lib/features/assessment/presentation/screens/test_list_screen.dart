import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:psychological_assessment/core/design_system/app_theme.dart';
import 'package:psychological_assessment/core/design_system/responsive.dart';
import 'package:psychological_assessment/core/design_system/theme_toggle_button.dart';
import 'package:psychological_assessment/features/upcoming/presentation/dialogs/upcoming_contact_dialog.dart';
import 'package:psychological_assessment/features/assessment/data/assessment_repository.dart';
import 'package:psychological_assessment/features/assessment/domain/assessment_models.dart';
import 'package:psychological_assessment/features/assessment/presentation/widgets/test_card.dart';
import 'package:psychological_assessment/core/widgets/mobile_bottom_nav.dart';
import 'package:psychological_assessment/core/widgets/test_empty_state.dart';
import 'package:psychological_assessment/core/widgets/test_search_field.dart';
import 'package:psychological_assessment/core/widgets/test_sort_menu.dart';
import 'package:psychological_assessment/core/widgets/web_top_nav.dart';

import 'package:psychological_assessment/features/assessment/domain/test_list_utils.dart';
import 'package:psychological_assessment/features/assessment/presentation/widgets/educational_banner.dart';
import 'package:psychological_assessment/features/assessment/presentation/widgets/test_list_header_title.dart';
import 'package:psychological_assessment/features/assessment/presentation/widgets/test_category_filter_bar.dart';

class TestListScreen extends ConsumerStatefulWidget {
  const TestListScreen({super.key});

  @override
  ConsumerState<TestListScreen> createState() => _TestListScreenState();
}

class _TestListScreenState extends ConsumerState<TestListScreen> {
  final _searchController = TextEditingController();
  String _searchQuery = '';
  String? _selectedCategory;
  String _sortBy = 'all';
  bool _sortAscending = true;
  bool _bannerDismissed = false;

  @override
  void initState() {
    super.initState();
    _loadBannerState();
    _searchController.addListener(() {
      setState(() => _searchQuery = _searchController.text);
    });
  }

  Future<void> _loadBannerState() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _bannerDismissed = prefs.getBool('edu_banner_dismissed') ?? false;
    });
  }

  Future<void> _dismissBanner() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('edu_banner_dismissed', true);
    setState(() => _bannerDismissed = true);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _refresh() {
    ref.invalidate(testListProvider);
    return ref.refresh(testListProvider.future);
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textTheme = Theme.of(context).textTheme;
    final testListAsync = ref.watch(testListProvider);

    return Title(
      title: 'Tests - Psychological Assessment',
      color: AppColors.primary,
      child: Scaffold(
      body: Column(
        children: [
          if (!isMobile)
            const WebTopNav(currentTab: 'tests'),

          Expanded(
            child: testListAsync.when(
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
              data: (tests) {
                final categories = tests
                    .map((t) => t.category)
                    .toSet()
                    .toList()
                  ..sort();

                final filteredTests = sortTestList(tests.where((test) {
                  final matchesCategory = _selectedCategory == null ||
                      test.category == _selectedCategory;
                  final matchesSearch = test.name
                          .toLowerCase()
                          .contains(_searchQuery.toLowerCase()) ||
                      test.description
                          .toLowerCase()
                          .contains(_searchQuery.toLowerCase());
                  return matchesCategory && matchesSearch;
                }).toList(), sortBy: _sortBy, ascending: _sortAscending);

                final columns = Responsive.gridColumns(context);
                final maxWidth = Responsive.maxContentWidth(context);

                return RefreshIndicator(
                  onRefresh: _refresh,
                  child: Center(
                    child: Container(
                      constraints: BoxConstraints(maxWidth: maxWidth),
                      child: CustomScrollView(
                        slivers: [
                          SliverToBoxAdapter(
                            child: _buildSearchAndFilters(
                              isDark: isDark,
                              textTheme: textTheme,
                              tests: tests,
                              categories: categories,
                            ),
                          ),
                          const SliverToBoxAdapter(
                            child: SizedBox(height: AppSpacing.sm),
                          ),
                          if (!_bannerDismissed)
                            SliverPadding(
                              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                              sliver: SliverToBoxAdapter(
                                child: EducationalBanner(
                                  onDismiss: _dismissBanner,
                                  onContactTap: () => showUpcomingContactDialog(
                                    context,
                                    isDark,
                                    textTheme,
                                    titleText: 'যোগাযোগ করুন',
                                    subtitleText: 'যে কোন প্রশ্ন বা মতামত জানাতে নিচের যেকোনো মাধ্যমে যোগাযোগ করুন।',
                                  ),
                                ),
                              ),
                            ),

                          if (filteredTests.isEmpty)
                            SliverFillRemaining(
                              child: TestEmptyState(
                                isDark: isDark,
                                textTheme: textTheme,
                              ),
                            )
                          else if (!isMobile)
                            SliverPadding(
                              padding: const EdgeInsets.all(AppSpacing.md),
                              sliver: SliverGrid(
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: columns,
                                  mainAxisSpacing: AppSpacing.md,
                                  crossAxisSpacing: AppSpacing.md,
                                  mainAxisExtent: 170,
                                ),
                                delegate: SliverChildBuilderDelegate(
                                  (context, index) => TestCard(
                                    test: filteredTests[index],
                                    uniformHeight: true,
                                  ),
                                  childCount: filteredTests.length,
                                ),
                              ),
                            )
                          else
                            SliverToBoxAdapter(
                              child: Padding(
                                padding:
                                    const EdgeInsets.all(AppSpacing.md),
                                child: MasonryGridView.count(
                                  crossAxisCount: columns,
                                  mainAxisSpacing: AppSpacing.md,
                                  crossAxisSpacing: AppSpacing.md,
                                  itemCount: filteredTests.length,
                                  shrinkWrap: true,
                                  physics:
                                      const NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) =>
                                      TestCard(
                                    test: filteredTests[index],
                                  ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          if (isMobile)
            MobileBottomNav(currentTab: 'tests'),
        ],
      ),
      ),
    );
  }

  Widget _buildSearchAndFilters({
    required bool isDark,
    required TextTheme textTheme,
    required List<TestListItem> tests,
    required List<String> categories,
  }) {
    final isDesktop = Responsive.isDesktop(context);
    final isTablet = Responsive.isTablet(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.sm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isDesktop)
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: TestListHeaderTitle(
                    textTheme: textTheme,
                    isDark: isDark,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 360),
                  child: TestSearchField(
                    controller: _searchController,
                    searchQuery: _searchQuery,
                    isDark: isDark,
                    textTheme: textTheme,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                TestSortMenu(
                  value: _sortBy,
                  sortAscending: _sortAscending,
                  isDark: isDark,
                  textTheme: textTheme,
                  onChanged: (val) => setState(() => _sortBy = val),
                  onToggleDirection: () => setState(() => _sortAscending = !_sortAscending),
                ),
              ],
            )
          else ...[
            Row(
              children: [
                Expanded(
                  child: TestListHeaderTitle(
                    textTheme: textTheme,
                    isDark: isDark,
                  ),
                ),
                const ThemeToggleButton(),
              ],
            ),
           const SizedBox(height: AppSpacing.lg),
            Row(
              children: [
                Expanded(
                  child: isTablet
                      ? ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 420),
                          child: TestSearchField(
                            controller: _searchController,
                            searchQuery: _searchQuery,
                            isDark: isDark,
                            textTheme: textTheme,
                          ),
                        )
                      : TestSearchField(
                          controller: _searchController,
                          searchQuery: _searchQuery,
                          isDark: isDark,
                          textTheme: textTheme,
                        ),
                ),
                const SizedBox(width: AppSpacing.sm),
                TestSortMenu(
                  value: _sortBy,
                  sortAscending: _sortAscending,
                  isDark: isDark,
                  textTheme: textTheme,
                  showLabel: false,
                  onChanged: (val) => setState(() => _sortBy = val),
                  onToggleDirection: () => setState(() => _sortAscending = !_sortAscending),
                ),
              ],
            ),
          ],
          const SizedBox(height: AppSpacing.md),

          TestCategoryFilterBar(
            categories: categories,
            tests: tests,
            selectedCategory: _selectedCategory,
            onCategoryChanged: (value) => setState(() => _selectedCategory = value),
          ),
        ],
      ),
    );
  }

}
