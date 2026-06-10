import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../../../core/design_system/app_theme.dart';
import '../../../core/design_system/responsive.dart';
import '../data/assessment_repository.dart';
import '../domain/assessment_models.dart';
import 'widgets/mobile_bottom_nav.dart';
import 'widgets/test_card.dart';
import 'widgets/test_empty_state.dart';
import 'widgets/test_filter_chip.dart';
import 'widgets/test_search_field.dart';
import 'widgets/test_sort_dropdown.dart';
import 'widgets/web_top_nav.dart';

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

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() => _searchQuery = _searchController.text);
    });
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

  List<TestListItem> _sorted(List<TestListItem> items) {
    switch (_sortBy) {
      case 'time':
        final sorted = List<TestListItem>.of(items);
        sorted.sort((a, b) => a.estimatedTimeMinutes.compareTo(b.estimatedTimeMinutes));
        return sorted;
      case 'severity':
        const order = {'High': 0, 'Medium': 1, 'Low': 2};
        final sorted = List<TestListItem>.of(items);
        sorted.sort((a, b) => (order[a.sensitivityLevel] ?? 3)
            .compareTo(order[b.sensitivityLevel] ?? 3));
        return sorted;
      case 'items':
        final sorted = List<TestListItem>.of(items);
        sorted.sort((a, b) => a.questionCount.compareTo(b.questionCount));
        return sorted;
      case 'name':
        final sorted = List<TestListItem>.of(items);
        sorted.sort((a, b) => a.name.compareTo(b.name));
        return sorted;
      default:
        return items;
    }
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

                final filteredTests = _sorted(tests.where((test) {
                  final matchesCategory = _selectedCategory == null ||
                      test.category == _selectedCategory;
                  final matchesSearch = test.name
                          .toLowerCase()
                          .contains(_searchQuery.toLowerCase()) ||
                      test.description
                          .toLowerCase()
                          .contains(_searchQuery.toLowerCase());
                  return matchesCategory && matchesSearch;
                }).toList());

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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Assessments',
                        style: textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        'Select a test to begin your assessment',
                        style: textTheme.bodyMedium?.copyWith(
                          color: isDark
                              ? AppColors.textSecondaryDark
                              : AppColors.textSecondary,
                        ),
                      ),
                    ],
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
                TestSortDropdown(
                  value: _sortBy,
                  isDark: isDark,
                  textTheme: textTheme,
                  onChanged: (val) => setState(() => _sortBy = val),
                ),
              ],
            )
          else ...[
            Text(
              'Assessments',
              style: textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                height: 1.2,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Select a test to begin your assessment',
              style: textTheme.bodyMedium?.copyWith(
                color: isDark
                    ? AppColors.textSecondaryDark
                    : AppColors.textSecondary,
              ),
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
                TestSortDropdown(
                  value: _sortBy,
                  isDark: isDark,
                  textTheme: textTheme,
                  onChanged: (val) => setState(() => _sortBy = val),
                ),
              ],
            ),
          ],
          const SizedBox(height: AppSpacing.md),

          SizedBox(
            height: 32,
            child: ListView(
              scrollDirection: Axis.horizontal,
              clipBehavior: Clip.none,
              children: [
                TestFilterChip(
                  label: 'All',
                  selected: _selectedCategory == null,
                  count: tests.length,
                  onTap: () =>
                      setState(() => _selectedCategory = null),
                ),
                const SizedBox(width: 8),
                ...categories.map(
                  (category) => Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: TestFilterChip(
                      label: category,
                      selected: _selectedCategory == category,
                      count: tests.where(
                              (t) => t.category == category)
                          .length,
                      onTap: () => setState(() =>
                          _selectedCategory =
                              _selectedCategory == category
                                  ? null
                                  : category),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

}
