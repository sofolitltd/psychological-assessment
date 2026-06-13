import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/design_system/app_theme.dart';
import '../../../../core/design_system/responsive.dart';
import '../../../../core/models/contributor.dart';
import '../../../../core/widgets/mobile_bottom_nav.dart';
import '../../../../core/widgets/web_top_nav.dart';

int _columns(double width) {
  if (width >= 768) return 3;
  if (width >= 480) return 2;
  return 1;
}

class AcknowledgementsScreen extends StatefulWidget {
  const AcknowledgementsScreen({super.key});

  @override
  State<AcknowledgementsScreen> createState() => _AcknowledgementsScreenState();
}

class _AcknowledgementsScreenState extends State<AcknowledgementsScreen> {
  final _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() => _searchQuery = _searchController.text.toLowerCase());
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isMobile = Responsive.isMobile(context);
    final maxWidth = Responsive.maxContentWidth(context);
    final textTheme = Theme.of(context).textTheme;

    final filtered = contributors.where((c) =>
      c.name.toLowerCase().contains(_searchQuery) ||
      c.institution.toLowerCase().contains(_searchQuery)
    ).toList();

    final searchField = Container(
      height: 40,
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surface,
        borderRadius: AppRadius.roundedSm,
        border: Border.all(color: isDark ? AppColors.borderDark : AppColors.border, width: 1),
      ),
      child: TextField(
        controller: _searchController,
        style: textTheme.bodyMedium,
        textAlignVertical: TextAlignVertical.center,
        decoration: InputDecoration(
          hintText: 'Search acknowledgements…',
          hintStyle: TextStyle(color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary),
          prefixIcon: Icon(LucideIcons.search, color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary, size: 20),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(LucideIcons.x, size: 18),
                  onPressed: () => _searchController.clear(),
                )
              : null,
          border: InputBorder.none,
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        ),
      ),
    );

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            if (!isMobile)
              const WebTopNav(currentTab: 'about'),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        constraints: BoxConstraints(maxWidth: maxWidth),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.lg, AppSpacing.sm, AppSpacing.sm),
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () => context.go('/about'),
                                child: Text('About', style: TextStyle(fontSize: 14, color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary)),
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 4),
                                child: Icon(LucideIcons.chevronRight, size: 14),
                              ),
                              Expanded(
                                child: Text('Acknowledgements', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary), overflow: TextOverflow.ellipsis),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Center(
                      child: Container(
                        constraints: BoxConstraints(maxWidth: maxWidth),
                        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: SizedBox(
                            width: Responsive.isDesktop(context) ? 400 : null,
                            child: searchField,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Center(
                      child: Container(
                        constraints: BoxConstraints(maxWidth: maxWidth),
                        padding: EdgeInsets.all(isMobile ? AppSpacing.md : AppSpacing.lg),
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            final spacing = 16.0;
                            final columns = _columns(constraints.maxWidth);
                            final childWidth = (constraints.maxWidth - spacing * (columns - 1)) / columns;

                            return Wrap(
                              spacing: spacing,
                              runSpacing: spacing,
                              alignment: WrapAlignment.start,
                              children: filtered.map((c) => SizedBox(
                                width: childWidth,
                                child: _AcknowledgementCard(c: c, isDark: isDark, textTheme: textTheme),
                              )).toList(),
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xl),
                  ],
                ),
              ),
            ),
            if (isMobile)
              const MobileBottomNav(currentTab: 'about'),
          ],
        ),
      ),
    );
  }
}

class _AcknowledgementCard extends StatelessWidget {
  final Contributor c;
  final bool isDark;
  final TextTheme textTheme;

  const _AcknowledgementCard({required this.c, required this.isDark, required this.textTheme});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surface,
        borderRadius: AppRadius.roundedMd,
        border: Border.all(color: isDark ? AppColors.borderDark : AppColors.border),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: AppColors.primary.withValues(alpha: 0.12),
            child: Text(c.initials, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.primary)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(c.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontWeight: FontWeight.bold, fontFamily: GoogleFonts.outfit().fontFamily, fontSize: 13)),
                const SizedBox(height: 2),
                Text(c.post, style: TextStyle(fontSize: 11, color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary, fontFamily: GoogleFonts.outfit().fontFamily)),
                Text(c.institution, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 10, color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary, fontFamily: GoogleFonts.outfit().fontFamily)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
