import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_spacing.dart';

class SettingsLayout extends StatelessWidget {
  final Widget child;
  final String currentRoute;

  const SettingsLayout({
    super.key,
    required this.child,
    required this.currentRoute,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppSpacing.screenPadding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Settings Sidebar
          SizedBox(
            width: 260,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'SYSTEM CONFIG',
                  style: AppTextStyles.pageTitle.copyWith(letterSpacing: 2),
                ),
                const SizedBox(height: 8),
                Text(
                  'ADMINISTRATIVE PROTOCOLS',
                  style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.bold, color: AppColors.primaryAccent),
                ),
                const SizedBox(height: 48),
                _SettingsNavItem(
                  title: 'PROFILE_INTEL',
                  icon: Icons.fingerprint_outlined,
                  isSelected: currentRoute == '/settings/profile',
                  onTap: () => context.go('/settings/profile'),
                ),
                _SettingsNavItem(
                  title: 'ACCOUNT_SECURITY',
                  icon: Icons.shield_outlined,
                  isSelected: currentRoute == '/settings/account',
                  onTap: () => context.go('/settings/account'),
                ),
                _SettingsNavItem(
                  title: 'NEURAL_CONFIG',
                  icon: Icons.psychology_outlined,
                  isSelected: currentRoute == '/settings/ai-config',
                  onTap: () => context.go('/settings/ai-config'),
                ),
                _SettingsNavItem(
                  title: 'CREDIT_DEPLOYS',
                  icon: Icons.account_balance_wallet_outlined,
                  isSelected: currentRoute == '/billing',
                  onTap: () => context.go('/billing'),
                ),
              ],
            ),
          ),
          const VerticalDivider(width: 64, color: AppColors.border),
          // Settings Content
          Expanded(
            child: child,
          ),
        ],
      ),
    );
  }
}

class _SettingsNavItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _SettingsNavItem({
    required this.title,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primaryAccent.withOpacity(0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(6),
        border: isSelected ? Border.all(color: AppColors.primaryAccent.withOpacity(0.3)) : null,
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: isSelected ? AppColors.primaryAccent : AppColors.textSecondary,
          size: 18,
        ),
        title: Text(
          title,
          style: AppTextStyles.caption.copyWith(
            color: isSelected ? AppColors.textPrimary : AppColors.textSecondary,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            letterSpacing: 1,
          ),
        ),
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        dense: true,
        hoverColor: AppColors.primaryAccent.withOpacity(0.05),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      ),
    );
  }
}
