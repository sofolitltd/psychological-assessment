import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/design_system/app_theme.dart';
import '../../../core/design_system/responsive.dart';
import '../data/assessment_repository.dart';
import '../domain/assessment_models.dart';
import 'widgets/mobile_bottom_nav.dart';
import 'widgets/test_card.dart';
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

                          if (filteredTests.isEmpty)
                            SliverFillRemaining(
                              child: _buildEmptyState(
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
        AppSpacing.lg,
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
                  child: _buildSearchField(isDark, textTheme),
                ),
                const SizedBox(width: AppSpacing.sm),
                _buildSortDropdown(isDark, textTheme),
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
                          child: _buildSearchField(isDark, textTheme),
                        )
                      : _buildSearchField(isDark, textTheme),
                ),
                const SizedBox(width: AppSpacing.sm),
                _buildSortDropdown(isDark, textTheme),
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
                _FilterChip(
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
                    child: _FilterChip(
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

  Widget _buildEmptyState({
    required bool isDark,
    required TextTheme textTheme,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              LucideIcons.searchX,
              size: 64,
              color: isDark
                  ? AppColors.textSecondaryDark
                  : AppColors.textSecondary,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'No assessments match your search',
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Try a different keyword or category.',
              style: textTheme.bodyMedium?.copyWith(
                color: isDark
                    ? AppColors.textSecondaryDark
                    : AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchField(bool isDark, TextTheme textTheme) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surface,
        borderRadius: AppRadius.roundedSm,
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.border,
          width: 1,
        ),
      ),
      child: Center(
        child: TextField(
          controller: _searchController,
          style: textTheme.bodyLarge,
          decoration: InputDecoration(
            hintText: 'Search assessments…',
            hintStyle: TextStyle(
              color: isDark
                  ? AppColors.textSecondaryDark
                  : AppColors.textSecondary,
            ),
            prefixIcon: Icon(
              LucideIcons.search,
              color: isDark
                  ? AppColors.textSecondaryDark
                  : AppColors.textSecondary,
              size: 20,
            ),
            suffixIcon: _searchQuery.isNotEmpty
                ? IconButton(
                    icon: const Icon(LucideIcons.x, size: 18),
                    onPressed: () {
                      _searchController.clear();
                      setState(() => _searchQuery = '');
                    },
                  )
                : null,
            border: InputBorder.none,
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
          
          ),
        ),
      ),
    );
  }

  Widget _buildSortDropdown(bool isDark, TextTheme textTheme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surface,
        borderRadius: AppRadius.roundedSm,
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.border,
          width: 0.5,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            LucideIcons.arrowUpDown,
            size: 16,
            color: isDark
                ? AppColors.textSecondaryDark
                : AppColors.textSecondary,
          ),
          const SizedBox(width: 6),
          DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _sortBy,
              isDense: true,
              style: textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w500,
              ),
              items: const [
                DropdownMenuItem(value: 'all', child: Text('All')),
                DropdownMenuItem(value: 'name', child: Text('Name')),
                DropdownMenuItem(value: 'time', child: Text('Time')),
                DropdownMenuItem(value: 'severity', child: Text('Severity')),
                DropdownMenuItem(value: 'items', child: Text('Items')),
              ],
              onChanged: (val) {
                if (val != null) setState(() => _sortBy = val);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final int count;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.selected,
    required this.count,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.primary
              : isDark
                  ? AppColors.surfaceDark
                  : AppColors.surface,
          borderRadius: AppRadius.roundedSm,
          border: Border.all(
            color: selected
                ? AppColors.primary
                : isDark
                    ? AppColors.borderDark
                    : AppColors.border,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
                color: selected ? Colors.white : null,
              ),
            ),
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.only(left: 5, top: 2, right: 5, bottom: 4),
              decoration: BoxDecoration(
                color: selected
                    ? Colors.white.withValues(alpha: 0.2)
                    : isDark
                        ? AppColors.textSecondaryDark.withValues(alpha: 0.2)
                        : AppColors.textSecondary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              
              child: Text(
                '$count',
                style: TextStyle(
                  fontSize: 11,
                  height: 1,
                  fontWeight: FontWeight.w600,
                  color: selected ? Colors.white : null,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
