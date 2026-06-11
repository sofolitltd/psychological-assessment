import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../../../core/design_system/app_theme.dart';
import '../../../core/design_system/responsive.dart';
import '../../assessment/presentation/widgets/mobile_bottom_nav.dart';
import '../../assessment/presentation/widgets/test_empty_state.dart';
import '../../assessment/presentation/widgets/test_filter_chip.dart';
import '../../assessment/presentation/widgets/test_search_field.dart';
import '../../assessment/presentation/widgets/test_sort_menu.dart';
import '../../assessment/presentation/widgets/web_top_nav.dart';
import '../data/upcoming_repository.dart';
import 'widgets/upcoming_join_banner.dart';
import 'widgets/upcoming_resource_dialog.dart';
import 'widgets/upcoming_test_card.dart';
import 'widgets/upcoming_test_model.dart';

class UpcomingScreen extends ConsumerStatefulWidget {
  const UpcomingScreen({super.key});

  @override
  ConsumerState<UpcomingScreen> createState() => _UpcomingScreenState();
}

class _UpcomingScreenState extends ConsumerState<UpcomingScreen> {
  final _searchController = TextEditingController();
  String _searchQuery = '';
  String? _selectedCategory;
  String _sortBy = 'all';
  bool _sortAscending = true;

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
    ref.invalidate(upcomingTestListProvider);
    return ref.refresh(upcomingTestListProvider.future);
  }

  List<UpcomingTestItem> _sorted(List<UpcomingTestItem> items) {
    if (_sortBy == 'all') {
      if (!_sortAscending) return items.reversed.toList();
      return items;
    }
    final sorted = List<UpcomingTestItem>.of(items);
    switch (_sortBy) {
      case 'severity':
        const order = {'High': 0, 'Medium': 1, 'Low': 2};
        sorted.sort((a, b) => (order[a.test.sensitivityLevel] ?? 3)
            .compareTo(order[b.test.sensitivityLevel] ?? 3));
        break;
      case 'items':
        sorted.sort((a, b) => a.test.questionCount.compareTo(b.test.questionCount));
        break;
      case 'name':
        sorted.sort((a, b) => a.test.name.compareTo(b.test.name));
        break;
    }
    if (!_sortAscending) return sorted.reversed.toList();
    return sorted;
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textTheme = Theme.of(context).textTheme;
    final listAsync = ref.watch(upcomingTestListProvider);

    return Title(
      title: 'Upcoming - Psychological Assessment',
      color: AppColors.primary,
      child: Scaffold(
      body: Column(
        children: [
          if (!isMobile)
            const WebTopNav(currentTab: 'upcoming'),

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
                final categories = items
                    .map((t) => t.test.category)
                    .toSet()
                    .toList()
                  ..sort();

                final filteredItems = _sorted(items.where((item) {
                  final matchesCategory = _selectedCategory == null ||
                      item.test.category == _selectedCategory;
                  final q = _searchQuery.toLowerCase();
                  final matchesSearch = q.isEmpty ||
                      item.test.name.toLowerCase().contains(q) ||
                      item.test.description.toLowerCase().contains(q);
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
                              items: items,
                              categories: categories,
                            ),
                          ),
                          const SliverToBoxAdapter(
                            child: SizedBox(height: AppSpacing.sm),
                          ),
                          SliverPadding(
                            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                            sliver: SliverToBoxAdapter(
                              child: UpcomingJoinBanner(isDark: isDark, textTheme: textTheme),
                            ),
                          ),

                          if (filteredItems.isEmpty)
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
                                  mainAxisExtent: 148,
                                ),
                                delegate: SliverChildBuilderDelegate(
                                  (context, index) => UpcomingTestCard(
                                    item: filteredItems[index],
                                    uniformHeight: true,
                                    onTap: () => showUpcomingResourceDialog(
                                      context,
                                      filteredItems[index],
                                      isDark,
                                      textTheme,
                                    ),
                                  ),
                                  childCount: filteredItems.length,
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
                                  itemCount: filteredItems.length,
                                  shrinkWrap: true,
                                  physics:
                                      const NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) =>
                                      UpcomingTestCard(
                                    item: filteredItems[index],
                                    onTap: () => showUpcomingResourceDialog(
                                      context,
                                      filteredItems[index],
                                      isDark,
                                      textTheme,
                                    ),
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
            const MobileBottomNav(currentTab: 'upcoming'),
        ],
      ),
      ),
    );
  }

  Widget _buildSearchAndFilters({
    required bool isDark,
    required TextTheme textTheme,
    required List<UpcomingTestItem> items,
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
                        'Upcoming Tests',
                        style: textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          height: 1.2,
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
            Text(
              'Upcoming Tests',
              style: textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                height: 1.2,
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

          SizedBox(
            height: 32,
            child: ListView(
              scrollDirection: Axis.horizontal,
              clipBehavior: Clip.none,
              children: [
                TestFilterChip(
                  label: 'All',
                  selected: _selectedCategory == null,
                  count: items.length,
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
                      count: items.where(
                              (t) => t.test.category == category)
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
