import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/design_system/app_theme.dart';
import '../../../core/design_system/responsive.dart';
import '../../../core/design_system/theme_toggle_button.dart';
import '../../../features/upcoming/presentation/widgets/upcoming_contact_dialog.dart';
import '../data/assessment_repository.dart';
import '../domain/assessment_models.dart';
import 'widgets/mobile_bottom_nav.dart';
import 'widgets/test_card.dart';
import 'widgets/test_empty_state.dart';
import 'widgets/test_filter_chip.dart';
import 'widgets/test_search_field.dart';
import 'widgets/test_sort_menu.dart';
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

  List<TestListItem> _sorted(List<TestListItem> items) {
    if (_sortBy == 'all') {
      if (!_sortAscending) return items.reversed.toList();
      return items;
    }
    final sorted = List<TestListItem>.of(items);
    switch (_sortBy) {
      case 'time':
        sorted.sort((a, b) => a.estimatedTimeMinutes.compareTo(b.estimatedTimeMinutes));
        break;
      case 'severity':
        const order = {'High': 0, 'Medium': 1, 'Low': 2};
        sorted.sort((a, b) => (order[a.sensitivityLevel] ?? 3)
            .compareTo(order[b.sensitivityLevel] ?? 3));
        break;
      case 'items':
        sorted.sort((a, b) => a.questionCount.compareTo(b.questionCount));
        break;
      case 'name':
        sorted.sort((a, b) => a.name.compareTo(b.name));
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
                          if (!_bannerDismissed)
                            SliverPadding(
                              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                              sliver: SliverToBoxAdapter(
                                child: _buildEducationalBanner(
                                  isDark: isDark,
                                  textTheme: textTheme,
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
                  child: Text(
                    'Assessments',
                    style: textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                    ),
                  ),
                ),
                const ThemeToggleButton(),
              ],
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

  Widget _buildEducationalBanner({
    required bool isDark,
    required TextTheme textTheme,
  }) {
    final notoSerif = GoogleFonts.notoSerifBengali();

    return GestureDetector(
      onTap: () => showUpcomingContactDialog(
        context,
        isDark,
        textTheme,
        titleText: 'যোগাযোগ করুন',
        subtitleText: 'যে কোন প্রশ্ন বা মতামত জানাতে নিচের যেকোনো মাধ্যমে যোগাযোগ করুন।',
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: 4),
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
              borderRadius: AppRadius.roundedSm,
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Expanded(
              child: Text(
                'এটি একটি শিক্ষামূলক প্রকল্প। শিক্ষক, শিক্ষার্থী এবং কমিউনিটির কাছ থেকে তথ্য সংগ্রহ করা হয়েছে। দয়া করে দায়িত্বশীলভাবে ব্যবহার করুন। যে কোন প্রশ্ন বা মতামত জানাতে এখানে ক্লিক করুন।',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white.withValues(alpha: 0.85),
                  fontFamily: notoSerif.fontFamily,
                ),
              ),
            ),
          ),
          Positioned(
            top:-5,
            right:-5,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                _dismissBanner();
              },
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.9),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  LucideIcons.x,
                  size: 14,
                  color: Colors.orange.withValues(alpha: 0.9),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
