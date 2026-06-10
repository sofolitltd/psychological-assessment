import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/design_system/app_theme.dart';
import '../../../core/design_system/responsive.dart';
import '../../assessment/presentation/widgets/mobile_bottom_nav.dart';
import '../../assessment/presentation/widgets/web_top_nav.dart';

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
        _buildHeader(isDark, textTheme),
        const SizedBox(height: AppSpacing.xl),
        _buildAboutSection(isDark, textTheme),
        const SizedBox(height: AppSpacing.lg),
        _buildFeaturesSection(isDark, textTheme),
        const SizedBox(height: AppSpacing.lg),
        _buildDisclaimerSection(isDark, textTheme),
        const SizedBox(height: AppSpacing.xl),
        const Divider(),
        const SizedBox(height: AppSpacing.lg),
        _buildDeveloperSection(isDark, textTheme),
        const SizedBox(height: AppSpacing.md),
        _buildConnectSection(isDark, textTheme),
        const SizedBox(height: AppSpacing.lg),
        _buildPoweredBySection(textTheme),
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
              _buildHeader(isDark, textTheme),
              const SizedBox(height: AppSpacing.xl),
              _buildAboutSection(isDark, textTheme),
              const SizedBox(height: AppSpacing.lg),
              _buildFeaturesSection(isDark, textTheme),
              const SizedBox(height: AppSpacing.lg),
              _buildDisclaimerSection(isDark, textTheme),
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
                _buildDeveloperSection(isDark, textTheme),
                const SizedBox(height: AppSpacing.md),
                _buildConnectSection(isDark, textTheme),
                const SizedBox(height: AppSpacing.lg),
                _buildPoweredBySection(textTheme),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(bool isDark, TextTheme textTheme) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: AppRadius.roundedMd,
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.border,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Image.asset(
                'assets/data/logo.png',
                height: 60,
                width: 60,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Psychological Assessment',
                  style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 2),
                Text(
                  'Version 1.0.0',
                  style: textTheme.bodySmall?.copyWith(
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAboutSection(bool isDark, TextTheme textTheme) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: AppRadius.roundedMd,
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.border,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Icon(LucideIcons.info, size: 14, color: AppColors.primary),
              ),
              const SizedBox(width: 10),
              Text('About', style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'A comprehensive psychological assessment platform '
            'designed for mental health professionals. '
            'This app provides validated psychological tests '
            'and screening tools to support clinical assessment '
            'and research.',
            style: textTheme.bodyMedium?.copyWith(height: 1.6),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturesSection(bool isDark, TextTheme textTheme) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: AppRadius.roundedMd,
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.border,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Icon(LucideIcons.listChecks, size: 14, color: AppColors.primary),
              ),
              const SizedBox(width: 10),
              Text('Features', style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          _FeatureRow(icon: LucideIcons.clipboardList, title: 'Validated Assessments', subtitle: 'Evidence-based psychological instruments', isDark: isDark, textTheme: textTheme),
          _FeatureRow(icon: LucideIcons.barChart3, title: 'Detailed Results', subtitle: 'Comprehensive score breakdowns and interpretations', isDark: isDark, textTheme: textTheme),
          _FeatureRow(icon: LucideIcons.shield, title: 'Privacy First', subtitle: 'All data remains on your device', isDark: isDark, textTheme: textTheme),
          _FeatureRow(icon: LucideIcons.refreshCw, title: 'Regular Updates', subtitle: 'New tests and features added regularly', isDark: isDark, textTheme: textTheme),
        ],
      ),
    );
  }

  Widget _buildDisclaimerSection(bool isDark, TextTheme textTheme) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: AppRadius.roundedMd,
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.border,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.amber.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Icon(LucideIcons.shieldAlert, size: 14, color: Colors.amber),
              ),
              const SizedBox(width: 10),
              Text('Disclaimer', style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'This application is intended for educational and '
            'research purposes. It does not replace professional '
            'psychological evaluation or diagnosis. Results '
            'should be interpreted by qualified mental health '
            'professionals.',
            style: textTheme.bodySmall?.copyWith(
              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
              height: 1.6,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeveloperSection(bool isDark, TextTheme textTheme) {
    return _InfoCard(
      isDark: isDark,
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Icon(LucideIcons.user, size: 14, color: AppColors.primary),
              ),
              const SizedBox(width: 10),
              Text('Developer', style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          ClipRRect(
            borderRadius: BorderRadius.circular(36),
            child: Image.network(
              'https://reyad.vercel.app/_next/image?url=%2Freyad1.png&w=256&q=75',
              height: 72,
              width: 72,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => const CircleAvatar(
                radius: 36,
                backgroundColor: AppColors.primary,
                child: Text('MR', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
              ),
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return const CircleAvatar(
                  radius: 36,
                  backgroundColor: AppColors.primary,
                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                );
              },
            ),
          ),
          const SizedBox(height: 12),
          Text('Md Asifuzzaman Reyad', style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text('App Developer', style: textTheme.bodySmall?.copyWith(color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary)),
        ],
      ),
    );
  }

  Widget _buildConnectSection(bool isDark, TextTheme textTheme) {
    return _InfoCard(
      isDark: isDark,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Icon(LucideIcons.messageCircle, size: 14, color: AppColors.primary),
              ),
              const SizedBox(width: 10),
              Text('Connect', style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          _SocialButton(icon: LucideIcons.messageSquare, label: 'Facebook', value: '/asifuzzamanreyad', url: 'https://www.facebook.com/asifuzzamanreyad', isDark: isDark, textTheme: textTheme),
          const SizedBox(height: AppSpacing.sm),
          _SocialButton(icon: LucideIcons.messageCircle, label: 'WhatsApp', value: '+880 1704-340860', url: 'https://wa.me/+8801704340860', isDark: isDark, textTheme: textTheme),
          const SizedBox(height: AppSpacing.sm),
          _SocialButton(icon: LucideIcons.briefcase, label: 'LinkedIn', value: '/in/asifuzzamanreyad', url: 'https://linkedin.com/in/asifuzzamanreyad', isDark: isDark, textTheme: textTheme),
          const SizedBox(height: AppSpacing.sm),
          _SocialButton(icon: LucideIcons.playCircle, label: 'YouTube', value: '@sofolitltd', url: 'https://youtube.com/@sofolitltd', isDark: isDark, textTheme: textTheme),
        ],
      ),
    );
  }

  Widget _buildPoweredBySection(TextTheme textTheme) {
    return Center(
      child: Column(
        children: [
          Text('Powered by', style: textTheme.bodySmall?.copyWith(color: AppColors.textSecondary)),
          const SizedBox(height: 4),
          GestureDetector(
            onTap: () => launchUrl(Uri.parse('https://sofolit.vercel.app')),
            child: Text(
              'Sofol IT',
              style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: AppColors.primary, decoration: TextDecoration.underline),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final bool isDark;
  final Widget child;

  const _InfoCard({required this.isDark, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surface,
        borderRadius: AppRadius.roundedMd,
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.border,
        ),
      ),
      child: child,
    );
  }
}

class _SocialButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final String url;
  final bool isDark;
  final TextTheme textTheme;

  const _SocialButton({
    required this.icon,
    required this.label,
    required this.value,
    required this.url,
    required this.isDark,
    required this.textTheme,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: () => launchUrl(Uri.parse(url)),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.roundedMd,
          ),
          side: BorderSide(
            color: isDark ? AppColors.borderDark : AppColors.border,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, size: 20, color: AppColors.primary),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: textTheme.bodySmall?.copyWith(
                      color: isDark
                          ? AppColors.textSecondaryDark
                          : AppColors.textSecondary,
                    ),
                  ),
                  Text(
                    value,
                    style: textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              LucideIcons.externalLink,
              size: 16,
              color: isDark
                  ? AppColors.textSecondaryDark
                  : AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}

class _FeatureRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool isDark;
  final TextTheme textTheme;

  const _FeatureRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.isDark,
    required this.textTheme,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: AppColors.primary, size: 20),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  subtitle,
                  style: textTheme.bodySmall?.copyWith(
                    color: isDark
                        ? AppColors.textSecondaryDark
                        : AppColors.textSecondary,
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
