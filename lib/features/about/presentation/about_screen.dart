import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/design_system/app_theme.dart';
import '../../../core/design_system/responsive.dart';
import '../../assessment/presentation/widgets/mobile_bottom_nav.dart';
import '../../assessment/presentation/widgets/web_top_nav.dart';
import 'widgets/about_about_section.dart';
import 'widgets/about_connect_section.dart';
import 'widgets/about_developer_section.dart';
import 'widgets/about_disclaimer_section.dart';
import 'widgets/about_features_section.dart';
import 'widgets/about_header_section.dart';
import 'widgets/about_powered_by.dart';

class AboutScreen extends ConsumerWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isMobile = Responsive.isMobile(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textTheme = Theme.of(context).textTheme;

    return Title(
      title: 'About - Psychological Assessment',
      color: AppColors.primary,
      child: Scaffold(
      body: Column(
        children: [
          if (!isMobile)
            const WebTopNav(currentTab: 'about'),
          Expanded(
            child: Center(
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: Responsive.maxContentWidth(context),
                ),
                padding: EdgeInsets.all(
                  isMobile ? AppSpacing.md : AppSpacing.lg,
                ),
                child: isMobile
                    ? _buildMobileLayout(isDark, textTheme)
                    : _buildDesktopLayout(context, isDark, textTheme),
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

  Widget _buildMobileLayout(bool isDark, TextTheme textTheme) {
    return ListView(
      children: [
        AboutHeaderSection(isDark: isDark, textTheme: textTheme),
        const SizedBox(height: AppSpacing.xl),
        AboutAboutSection(isDark: isDark, textTheme: textTheme),
        const SizedBox(height: AppSpacing.lg),
        AboutFeaturesSection(isDark: isDark, textTheme: textTheme),
        const SizedBox(height: AppSpacing.lg),
        AboutDisclaimerSection(isDark: isDark, textTheme: textTheme),
        const SizedBox(height: AppSpacing.xl),
        const Divider(),
        const SizedBox(height: AppSpacing.lg),
        AboutDeveloperSection(isDark: isDark, textTheme: textTheme),
        const SizedBox(height: AppSpacing.md),
        AboutConnectSection(isDark: isDark, textTheme: textTheme),
        const SizedBox(height: AppSpacing.lg),
        AboutPoweredBy(textTheme: textTheme),
        const SizedBox(height: AppSpacing.xl),
      ],
    );
  }

  Widget _buildDesktopLayout(BuildContext context, bool isDark, TextTheme textTheme) {
    final isDesktop = Responsive.isDesktop(context);
    final leftFlex = isDesktop ? 4 : 3;
    final rightFlex = isDesktop ? 3 : 2;
    final gap = isDesktop ? 24.0 : 16.0;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: leftFlex,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
            children: [
              AboutHeaderSection(isDark: isDark, textTheme: textTheme),
              const SizedBox(height: AppSpacing.xl),
              AboutAboutSection(isDark: isDark, textTheme: textTheme),
              const SizedBox(height: AppSpacing.lg),
              AboutFeaturesSection(isDark: isDark, textTheme: textTheme),
              const SizedBox(height: AppSpacing.lg),
              AboutDisclaimerSection(isDark: isDark, textTheme: textTheme),
            ],
          ),
        ),
        SizedBox(width: gap),
        Expanded(
          flex: rightFlex,
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AboutDeveloperSection(isDark: isDark, textTheme: textTheme),
                const SizedBox(height: AppSpacing.md),
                AboutConnectSection(isDark: isDark, textTheme: textTheme),
                const SizedBox(height: AppSpacing.lg),
                AboutPoweredBy(textTheme: textTheme),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
