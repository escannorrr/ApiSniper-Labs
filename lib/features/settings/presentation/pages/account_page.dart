import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../widgets/settings_layout.dart';
import '../bloc/account_bloc.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../../core/widgets/command_loader.dart';
import '../../../../core/widgets/command_snackbar.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_spacing.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final _passwordFormKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SettingsLayout(
      currentRoute: '/settings/account',
      child: BlocConsumer<AccountBloc, AccountState>(
        listener: (context, state) {
          if (state is PasswordChangeSuccess) {
            _currentPasswordController.clear();
            _newPasswordController.clear();
            _confirmPasswordController.clear();
            CommandSnackbar.showSuccess(context, 'SECURITY OVERRIDE COMPLETE: PASSWORD UPDATED');
          } else if (state is AccountDeletedSuccess) {
            CommandSnackbar.showSuccess(context, 'IDENTITY PURGED. CONNECTION TERMINATED.');
            context.read<AuthBloc>().add(AuthLogoutRequested());
          } else if (state is AccountError) {
            CommandSnackbar.showError(context, state.message);
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildChangePasswordSection(context, state),
                const SizedBox(height: 64),
                _buildDeleteAccountSection(context, state),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildChangePasswordSection(BuildContext context, AccountState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.security_outlined, color: AppColors.primaryAccent, size: 24),
            const SizedBox(width: 12),
            Text(
              'SECURITY PROTOCOLS',
              style: AppTextStyles.sectionTitle.copyWith(letterSpacing: 2),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'UPDATE ACCESS CREDENTIALS FOR ENHANCED ENCRYPTION.',
          style: AppTextStyles.caption.copyWith(fontSize: 10),
        ),
        const SizedBox(height: 32),
        Container(
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
            border: Border.all(color: AppColors.border),
          ),
          child: Padding(
            padding: AppSpacing.cardInsets,
            child: Form(
              key: _passwordFormKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildPasswordField(
                    label: 'EXISTING_CREDENTIAL',
                    controller: _currentPasswordController,
                  ),
                  const SizedBox(height: 24),
                  _buildPasswordField(
                    label: 'NEW_ENCRYPTION_KEY',
                    controller: _newPasswordController,
                  ),
                  const SizedBox(height: 24),
                  _buildPasswordField(
                    label: 'CONFIRM_KEY',
                    controller: _confirmPasswordController,
                    validator: (value) {
                      if (value != _newPasswordController.text) {
                        return 'KEY MISMATCH DETECTED';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 48),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (state is AccountLoading)
                        const Padding(
                          padding: EdgeInsets.only(right: 24.0),
                          child: CommandLoader(fullScreen: false, message: 'ENCRYPTING...'),
                        ),
                      FilledButton.icon(
                        onPressed: state is AccountLoading 
                          ? null 
                          : () {
                          if (_passwordFormKey.currentState!.validate()) {
                            context.read<AccountBloc>().add(
                                  ChangePasswordRequested(
                                    currentPassword: _currentPasswordController.text,
                                    newPassword: _newPasswordController.text,
                                  ),
                                );
                          }
                        },
                        icon: const Icon(Icons.lock_reset_outlined, size: 18),
                        label: const Text('REPROGRAM ACCESS'),
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 18),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDeleteAccountSection(BuildContext context, AccountState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.dangerous_outlined, color: AppColors.error, size: 24),
            const SizedBox(width: 12),
            Text(
              'CRITICAL OVERRIDE ZONE',
              style: AppTextStyles.sectionTitle.copyWith(color: AppColors.error, letterSpacing: 2),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.error.withOpacity(0.05),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.error.withOpacity(0.3)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'WARNING: ACCOUNT DELETION IS IRREVERSIBLE. ALL MISSION DATA, PROJECT SCHEMAS, AND SCAN LOGS WILL BE PURGED FROM THE SYSTEM PERMANENTLY.',
                style: AppTextStyles.caption.copyWith(color: AppColors.error, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              OutlinedButton.icon(
                onPressed: state is AccountLoading 
                  ? null 
                  : () => _showDeleteConfirmation(context),
                icon: const Icon(Icons.delete_forever_outlined, color: AppColors.error, size: 18),
                label: const Text('PURGE IDENTITY', style: TextStyle(color: AppColors.error)),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.error),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.sidebarBackground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(color: AppColors.error, width: 2),
        ),
        title: Text(
          'PURGE CONFIRMATION', 
          style: AppTextStyles.sectionTitle.copyWith(color: AppColors.error, letterSpacing: 2),
        ),
        content: Text(
          'ARE YOU ABSOLUTELY SURE? THIS ACTION WILL ERASE ALL TRACES OF THIS IDENTITY FROM THE COMMAND CENTER FOREVER.',
          style: AppTextStyles.bodyText,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text('ABORT', style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.bold)),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              context.read<AccountBloc>().add(DeleteAccountRequested());
            },
            style: FilledButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('CONFIRM PURGE'),
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordField({
    required String label,
    required TextEditingController controller,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.bold, letterSpacing: 1, fontFamily: 'monospace'),
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: controller,
          obscureText: true,
          style: AppTextStyles.bodyText.copyWith(fontFamily: 'monospace'),
          decoration: InputDecoration(
            hintText: '********',
            hintStyle: AppTextStyles.caption.copyWith(color: AppColors.textSecondary.withOpacity(0.3)),
            filled: true,
            fillColor: AppColors.sidebarBackground.withOpacity(0.5),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: BorderSide(color: AppColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: BorderSide(color: AppColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: BorderSide(color: AppColors.primaryAccent),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
          validator: validator ?? (value) {
            if (value == null || value.isEmpty) {
              return 'CREDENTIAL REQUIRED';
            }
            if (value.length < 6) {
              return 'KEY STRENGTH INSUFFICIENT (MIN 6)';
            }
            return null;
          },
        ),
      ],
    );
  }
}
