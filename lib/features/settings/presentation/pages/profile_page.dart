import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../widgets/settings_layout.dart';
import '../bloc/profile_bloc.dart';
import '../../../../core/widgets/command_loader.dart';
import '../../../../core/widgets/command_snackbar.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_spacing.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _companyController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<ProfileBloc>().add(LoadProfileRequested());
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _companyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SettingsLayout(
      currentRoute: '/settings/profile',
      child: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ProfileLoaded) {
            _nameController.text = state.profile.name;
            _emailController.text = state.profile.email;
            _companyController.text = state.profile.company ?? '';
          } else if (state is ProfileUpdated) {
             _nameController.text = state.profile.name;
            _emailController.text = state.profile.email;
            _companyController.text = state.profile.company ?? '';
            CommandSnackbar.showSuccess(context, 'IDENTITY PARAMETERS RECALIBRATED');
          } else if (state is ProfileError) {
            CommandSnackbar.showError(context, state.message);
          }
        },
        builder: (context, state) {
          if (state is ProfileLoading) {
            return const CommandLoader(fullScreen: false);
          }

          return SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   Row(
                     children: [
                       const Icon(Icons.badge_outlined, color: AppColors.primaryAccent, size: 24),
                       const SizedBox(width: 12),
                       Text(
                        'IDENTITY MATRIX',
                        style: AppTextStyles.sectionTitle.copyWith(letterSpacing: 2),
                                          ),
                     ],
                   ),
                  const SizedBox(height: 8),
                  Text(
                    'UPDATE OPERATOR BIOMETRICS AND ASSIGNMENT DATA.',
                    style: AppTextStyles.caption.copyWith(fontSize: 10),
                  ),
                  const SizedBox(height: 48),
                  
                  // Avatar Section
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: AppColors.sidebarBackground.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: AppColors.primaryAccent.withOpacity(0.1),
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.primaryAccent.withOpacity(0.5), width: 2),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            _nameController.text.isNotEmpty ? _nameController.text[0].toUpperCase() : 'U',
                            style: AppTextStyles.pageTitle.copyWith(
                              fontSize: 32,
                              color: AppColors.primaryAccent,
                            ),
                          ),
                        ),
                        const SizedBox(width: 32),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            OutlinedButton.icon(
                              onPressed: () {
                                // Avatar change logic
                              },
                              icon: const Icon(Icons.add_a_photo_outlined, size: 16),
                              label: const Text('RELOAD BIOMETRICS'),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'IMAGE FORMAT: JPG, PNG (MAX 2MB)',
                              style: AppTextStyles.caption.copyWith(fontSize: 9),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 48),
                  
                  // Form Fields
                  _buildTextField(
                    label: 'OPERATOR_NAME',
                    controller: _nameController,
                    hint: 'IDENTIFY YOURSELF',
                  ),
                  const SizedBox(height: 32),
                  _buildTextField(
                    label: 'COMMS_CHANNEL',
                    controller: _emailController,
                    hint: 'SECURE EMAIL',
                    enabled: false,
                  ),
                  const SizedBox(height: 32),
                  _buildTextField(
                    label: 'COMMAND_ENTITY (OPTIONAL)',
                    controller: _companyController,
                    hint: 'ORGANIZATION CODE',
                  ),
                  const SizedBox(height: 64),
                  
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (state is ProfileUpdating)
                        const Padding(
                          padding: EdgeInsets.only(right: 24.0),
                          child: CommandLoader(fullScreen: false, message: 'SYNCHRONIZING...'),
                        ),
                      FilledButton.icon(
                        onPressed: state is ProfileUpdating 
                          ? null 
                          : () {
                          if (_formKey.currentState!.validate()) {
                            context.read<ProfileBloc>().add(
                                  UpdateProfileRequested(
                                    name: _nameController.text,
                                    company: _companyController.text,
                                  ),
                                );
                          }
                        },
                        icon: const Icon(Icons.sync_alt, size: 18),
                        label: const Text('COMMIT CHANGES'),
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 18),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required String hint,
    bool enabled = true,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.bold, letterSpacing: 1),
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: controller,
          enabled: enabled,
          style: AppTextStyles.bodyText.copyWith(
            color: enabled ? AppColors.textPrimary : AppColors.textSecondary,
            fontFamily: enabled ? null : 'monospace',
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: AppTextStyles.caption.copyWith(color: AppColors.textSecondary.withOpacity(0.5)),
            filled: true,
            fillColor: enabled ? Colors.transparent : AppColors.sidebarBackground.withOpacity(0.5),
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
              borderSide: BorderSide(color: AppColors.primaryAccent, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'FIELD REQUIREMENT NOT MET';
            }
            return null;
          },
        ),
      ],
    );
  }
}
