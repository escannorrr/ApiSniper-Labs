import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(32),
      children: [
        _buildSettingsMenu(context),
      ],
    );
  }

  Widget _buildSettingsMenu(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Settings',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 32),
        _buildMenuCard(
          context,
          title: 'Profile',
          subtitle: 'Update your personal information and preferences',
          icon: Icons.person_outline,
          onTap: () => context.go('/settings/profile'),
        ),
        const SizedBox(height: 16),
        _buildMenuCard(
          context,
          title: 'AI Configuration',
          subtitle: 'Configure OpenAI API keys and select models',
          icon: Icons.smart_toy_outlined,
          onTap: () => context.go('/settings/ai-config'),
        ),
        const SizedBox(height: 16),
        _buildMenuCard(
          context,
          title: 'Account',
          subtitle: 'Manage account security and password',
          icon: Icons.security_outlined,
          onTap: () => context.go('/settings/account'),
        ),
        const SizedBox(height: 16),
        _buildMenuCard(
          context,
          title: 'Billing',
          subtitle: 'Manage subscription and payment methods',
          icon: Icons.credit_card_outlined,
          onTap: () => context.go('/billing'),
        ),
      ],
    );
  }

  Widget _buildMenuCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 0,
       shape: RoundedRectangleBorder(
        side: BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        leading: Container(
           padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.5),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: Theme.of(context).colorScheme.primary),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
