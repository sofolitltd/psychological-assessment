import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '/features/auth/domain/auth_providers.dart';

import '../../../../core/design_system/app_theme.dart';
import '../../../../core/design_system/responsive.dart';
import '../../../../core/widgets/mobile_bottom_nav.dart';
import '../../../../core/widgets/web_top_nav.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  bool _isLoading = false;

  Future<void> _signIn() async {
    setState(() => _isLoading = true);
    try {
      await ref.read(authServiceProvider).signInWithGoogle();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('লগইন ব্যর্থ: $e')));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isMobile = Responsive.isMobile(context);
    final isDesktop = Responsive.isDesktop(context);
    final textTheme = Theme.of(context).textTheme;
    final notoSerif = GoogleFonts.notoSerifBengali();
    final maxWidth = Responsive.maxContentWidth(context);
    final user = ref.watch(currentUserProvider);
    final statsAsync = ref.watch(userStatsProvider);

    return Title(
      title: 'Profile - Psychological Assessment',
      color: AppColors.primary,
      child: Scaffold(
        body: Column(
          children: [
            if (!isMobile) const WebTopNav(currentTab: 'profile'),
            Expanded(
              child: Center(
                child: Container(
                  constraints: BoxConstraints(maxWidth: maxWidth),
                  padding: EdgeInsets.all(
                    isMobile ? AppSpacing.md : AppSpacing.lg,
                  ),
                  child: isMobile
                      ? _mobileBody(
                          isDark,
                          textTheme,
                          notoSerif,
                          user,
                          statsAsync,
                        )
                      : _desktopBody(
                          isDark,
                          textTheme,
                          notoSerif,
                          isDesktop,
                          user,
                          statsAsync,
                        ),
                ),
              ),
            ),
            if (isMobile) const MobileBottomNav(currentTab: 'profile'),
          ],
        ),
      ),
    );
  }

  Widget _mobileBody(
    bool isDark,
    TextTheme textTheme,
    TextStyle notoSerif,
    dynamic user,
    AsyncValue<UserStats?> statsAsync,
  ) {
    return ListView(
      children: [
        const SizedBox(height: AppSpacing.sm),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Profile',
              style: textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                height: 1.2,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Manage your account and view stats',
              style: textTheme.bodyMedium?.copyWith(
                color: isDark
                    ? AppColors.textSecondaryDark
                    : AppColors.textSecondary,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        if (user != null) ...[
          _profileHeader(isDark, textTheme, notoSerif, user),
          const SizedBox(height: AppSpacing.md),
          _statsCard(isDark, textTheme, notoSerif, statsAsync),
          const SizedBox(height: AppSpacing.md),
          _settingsCard(isDark, textTheme, notoSerif, user),
        ] else
          _loginPrompt(isDark, textTheme, notoSerif),
      ],
    );
  }

  Widget _desktopBody(
    bool isDark,
    TextTheme textTheme,
    TextStyle notoSerif,
    bool isDesktop,
    dynamic user,
    AsyncValue<UserStats?> statsAsync,
  ) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.only(
              bottom: isDesktop ? AppSpacing.xl : AppSpacing.lg,
            ),
            child: Text(
              'Profile',
              style: textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                height: 1.2,
              ),
            ),
          ),
        ),
        if (user != null)
          SliverFillRemaining(
            hasScrollBody: false,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: isDesktop ? 5 : 4,
                  child: Column(
                    children: [
                      _profileHeader(isDark, textTheme, notoSerif, user),
                      const SizedBox(height: AppSpacing.md),
                      _settingsCard(isDark, textTheme, notoSerif, user),
                    ],
                  ),
                ),
                SizedBox(width: isDesktop ? 24 : 16),
                Expanded(
                  flex: isDesktop ? 4 : 3,
                  child: _statsCard(isDark, textTheme, notoSerif, statsAsync),
                ),
              ],
            ),
          )
        else
          SliverToBoxAdapter(child: _loginPrompt(isDark, textTheme, notoSerif)),
      ],
    );
  }

  Widget _profileHeader(
    bool isDark,
    TextTheme textTheme,
    TextStyle notoSerif,
    dynamic user,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        vertical: AppSpacing.xl,
        horizontal: AppSpacing.lg,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [
                  AppColors.primary.withValues(alpha: 0.2),
                  AppColors.surfaceDark,
                ]
              : [AppColors.primary.withValues(alpha: 0.08), AppColors.surface],
        ),
        borderRadius: AppRadius.roundedLg,
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.border,
          width: 0.5,
        ),
      ),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.2),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: CircleAvatar(
              radius: 52,
              backgroundColor: AppColors.primary.withValues(alpha: 0.12),
              backgroundImage: user.photoURL != null
                  ? NetworkImage(user.photoURL!)
                  : null,
              child: user.photoURL == null
                  ? Icon(
                      LucideIcons.circleUser,
                      size: 48,
                      color: AppColors.primary,
                    )
                  : null,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            user.displayName ?? 'ব্যবহারকারী',
            style: textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              fontFamily: notoSerif.fontFamily,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                LucideIcons.mail,
                size: 14,
                color: isDark
                    ? AppColors.textSecondaryDark
                    : AppColors.textSecondary,
              ),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  user.email ?? '',
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark
                        ? AppColors.textSecondaryDark
                        : AppColors.textSecondary,
                    fontFamily: notoSerif.fontFamily,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statsCard(
    bool isDark,
    TextTheme textTheme,
    TextStyle notoSerif,
    AsyncValue<UserStats?> statsAsync,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surface,
        borderRadius: AppRadius.roundedLg,
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
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  LucideIcons.barChart3,
                  size: 18,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'পরিসংখ্যান',
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontFamily: notoSerif.fontFamily,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          statsAsync.when(
            data: (stats) {
              if (stats == null) return const SizedBox.shrink();
              return Column(
                children: [
                  _statItem(
                    icon: LucideIcons.clipboardList,
                    label: 'পরীক্ষা দেওয়া হয়েছে',
                    value: '${stats.usageCount} টি',
                    isDark: isDark,
                    notoSerif: notoSerif,
                  ),
                  if (stats.createdAt != null) ...[
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: AppSpacing.sm),
                      child: Divider(height: 1),
                    ),
                    _statItem(
                      icon: LucideIcons.calendarPlus,
                      label: 'সদস্য হয়েছেন',
                      value: DateFormat('MMM yyyy').format(stats.createdAt!),
                    notoSerif: notoSerif,
                      isDark: isDark,
                    ),
                  ],
                  if (stats.lastLogin != null) ...[
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: AppSpacing.sm),
                      child: Divider(height: 1),
                    ),
                    _statItem(
                      icon: LucideIcons.clock,
                      label: 'সর্বশেষ লগইন',
                      value: _lastLoginText(stats.lastLogin!),
                    notoSerif: notoSerif,
                      isDark: isDark,
                    ),
                  ],
                ],
              );
            },
            loading: () => const Center(
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
            error: (_, _) => Text(
              'তথ্য লোড করতে ব্যর্থ',
              style: TextStyle(
                fontFamily: notoSerif.fontFamily,
                color: isDark
                    ? AppColors.textSecondaryDark
                    : AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _statItem({
    required IconData icon,
    required String label,
    required String value,
    required bool isDark,
    required TextStyle notoSerif,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(icon, size: 16, color: AppColors.primary),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontFamily: notoSerif.fontFamily,
              color: isDark
                  ? AppColors.textSecondaryDark
                  : AppColors.textSecondary,
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _settingsCard(
    bool isDark,
    TextTheme textTheme,
    TextStyle notoSerif,
    dynamic user,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surface,
        borderRadius: AppRadius.roundedLg,
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
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  LucideIcons.settings,
                  size: 18,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'অ্যাকাউন্ট',
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontFamily: notoSerif.fontFamily,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          _settingsTile(
            icon: LucideIcons.logOut,
            label: 'সাইন আউট',
            color: Colors.red,
            onTap: () => _confirmSignOut(notoSerif),
            isDark: isDark,
            notoSerif: notoSerif,

          ),
        ],
      ),
    );
  }

  Widget _settingsTile({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
    required bool isDark,
    required TextStyle notoSerif,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: AppSpacing.sm,
          horizontal: 4,
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, size: 18, color: color),
            ),
            const SizedBox(width: AppSpacing.md),
            Text(
              label,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: color,
                fontFamily: notoSerif.fontFamily
              ),
            ),
            const Spacer(),
            Icon(
              LucideIcons.chevronRight,
              size: 18,
              color: isDark
                  ? AppColors.textSecondaryDark
                  : AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmSignOut(TextStyle notoSerif) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: AppRadius.roundedMd),
        title: Text(
          'সাইন আউট',
          style: TextStyle(fontFamily: notoSerif.fontFamily),
        ),
        content: Text(
          'আপনি কি সাইন আউট করতে চান?',
          style: TextStyle(fontFamily: notoSerif.fontFamily),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(
              'বাতিল',
              style: TextStyle(fontFamily: notoSerif.fontFamily),
            ),
          ),
          OutlinedButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text(
              'সাইন আউট',
              style: TextStyle(fontFamily: notoSerif.fontFamily),
            ),
          ),
        ],
      ),
    );
    if (confirmed == true && mounted) {
      await ref.read(authServiceProvider).signOut();
    }
  }

  Widget _loginPrompt(bool isDark, TextTheme textTheme, TextStyle notoSerif) {
    return Center(
      child: Container(
        width: double.infinity,

        padding: EdgeInsets.all(
          Responsive.isMobile(context) ? AppSpacing.lg : AppSpacing.xl,
        ),
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceDark : AppColors.surface,
          borderRadius: AppRadius.roundedLg,
          border: Border.all(
            color: isDark ? AppColors.borderDark : AppColors.border,
            width: 0.5,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                LucideIcons.circleUser,
                size: 40,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'আপনি লগইন করেননি',
              style: textTheme.titleMedium?.copyWith(
                fontFamily: notoSerif.fontFamily,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'প্রোফাইল দেখতে এবং PDF ডাউনলোড করতে লগইন করুন।',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: notoSerif.fontFamily,
                color: isDark
                    ? AppColors.textSecondaryDark
                    : AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            SizedBox(
              height: 48,
              width: 210,
              child: ElevatedButton.icon(
                icon: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    :  SizedBox(width:  20, height: 20, child: Image.asset("assets/images/google.png"),),
                label: Text(
                  _isLoading ? 'লগইন হচ্ছে...' : 'Google দিয়ে লগইন করুন',
                  style: TextStyle(fontFamily: notoSerif.fontFamily),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: AppRadius.roundedSm,
                  ),
                ),
                onPressed: _isLoading ? null : _signIn,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _lastLoginText(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);
    if (diff.inMinutes < 1) return 'এইমাত্র';
    if (diff.inHours < 1) return '${diff.inMinutes} মি. আগে';
    if (diff.inDays < 1) return '${diff.inHours} ঘ. আগে';
    if (diff.inDays < 7) return '${diff.inDays} দি. আগে';
    return DateFormat('dd MMM yyyy').format(date);
  }
}
