import 'package:flutter/material.dart';
import '../widgets/settings_layout.dart';
import '../../../../core/widgets/command_loader.dart';
import '../../../../core/widgets/command_snackbar.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_spacing.dart';

class AiSettingsPage extends StatefulWidget {
  const AiSettingsPage({super.key});

  @override
  State<AiSettingsPage> createState() => _AiSettingsPageState();
}

class _AiSettingsPageState extends State<AiSettingsPage> {
  final _apiKeyController = TextEditingController();
  final _preferencesController = TextEditingController();
  String _selectedModel = 'gpt-4o';
  bool _isSaving = false;

  final List<String> _models = ['gpt-4o', 'gpt-4o-mini', 'gpt-3.5-turbo'];

  @override
  void initState() {
    super.initState();
    // Simulate loading keys
    _apiKeyController.text = 'sk-proj-...'; 
    _preferencesController.text = 'Focus on security implications and edge-case generation for the financial API domains.';
  }

  @override
  void dispose() {
    _apiKeyController.dispose();
    _preferencesController.dispose();
    super.dispose();
  }

  Future<void> _saveSettings() async {
    setState(() => _isSaving = true);
    await Future.delayed(const Duration(seconds: 1)); // Mock saving
    setState(() => _isSaving = false);
    if(mounted) {
       CommandSnackbar.showSuccess(context, 'NEURAL PARAMETERS ENCRYPTED: CONFIGURATION SAVED');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SettingsLayout(
      currentRoute: '/settings/ai-config',
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             Row(
               children: [
                 const Icon(Icons.psychology_outlined, color: AppColors.primaryAccent, size: 24),
                 const SizedBox(width: 12),
                 Text(
                    'NEURAL ENGINE CONFIG',
                    style: AppTextStyles.sectionTitle.copyWith(letterSpacing: 2),
                 ),
               ],
             ),
             const SizedBox(height: 8),
             Text(
               'CONFIGURE THE ANALYTICAL CORE FOR MISSION-CRITICAL AUTOMATION.', 
               style: AppTextStyles.caption.copyWith(fontSize: 10),
             ),
             
             const SizedBox(height: 48),
             Container(
                decoration: BoxDecoration(
                  color: AppColors.cardBackground,
                  borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
                  border: Border.all(color: AppColors.border),
                ),
                child: Padding(
                   padding: AppSpacing.cardInsets,
                   child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                         Text(
                           'QUANTUM_API_KEY', 
                           style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.bold, letterSpacing: 1, fontFamily: 'monospace'),
                         ),
                         const SizedBox(height: 16),
                         TextField(
                            controller: _apiKeyController,
                            obscureText: true,
                            style: AppTextStyles.codeText,
                            decoration: InputDecoration(
                               border: const OutlineInputBorder(),
                               hintText: 'sk-xxxxxxxxxxxxxxxxxxxx',
                               hintStyle: AppTextStyles.caption.copyWith(color: AppColors.textSecondary.withOpacity(0.3)),
                               helperText: 'ENCRYPTED AT REST. KEYS RESIDE IN SECURE LOCAL ARCHIVE.',
                               helperStyle: AppTextStyles.caption.copyWith(fontSize: 9, color: AppColors.primaryAccent.withOpacity(0.7)),
                               prefixIcon: const Icon(Icons.vpn_key_outlined, size: 18),
                            ),
                         ),
                         const SizedBox(height: 40),
                         Text(
                           'TACTICAL_MODEL_SELECTION', 
                           style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.bold, letterSpacing: 1, fontFamily: 'monospace'),
                         ),
                         const SizedBox(height: 12),
                         Text(
                           'DEFINE THE PRIMARY NEURAL ARCHITECTURE FOR DATA PROCESSING.', 
                           style: AppTextStyles.caption.copyWith(fontSize: 10, color: AppColors.textSecondary),
                         ),
                         const SizedBox(height: 16),
                         SizedBox(
                            width: 350,
                            child: DropdownButtonFormField<String>(
                               value: _selectedModel,
                               dropdownColor: AppColors.sidebarBackground,
                               style: AppTextStyles.bodyText.copyWith(fontWeight: FontWeight.bold),
                               decoration: InputDecoration(
                                 border: const OutlineInputBorder(), 
                                 prefixIcon: const Icon(Icons.settings_input_component_outlined, size: 18),
                                 fillColor: AppColors.sidebarBackground.withOpacity(0.5),
                                 filled: true,
                               ),
                               items: _models.map((model) => DropdownMenuItem(
                                 value: model, 
                                 child: Text(model.toUpperCase(), style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.bold)),
                               )).toList(),
                               onChanged: (val) {
                                  if (val != null) setState(() => _selectedModel = val);
                               },
                            ),
                         ),
                         
                         const SizedBox(height: 40),
                         Text(
                           'HEURISTIC_PREFERENCES', 
                           style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.bold, letterSpacing: 1, fontFamily: 'monospace'),
                         ),
                         const SizedBox(height: 16),
                         TextField(
                            controller: _preferencesController,
                            maxLines: 5,
                            style: AppTextStyles.bodyText,
                            decoration: InputDecoration(
                               border: const OutlineInputBorder(),
                               hintText: 'DEPLOY CUSTOM LOGIC PARAMETERS...',
                               hintStyle: AppTextStyles.caption.copyWith(color: AppColors.textSecondary.withOpacity(0.3)),
                               fillColor: AppColors.sidebarBackground.withOpacity(0.5),
                               filled: true,
                            ),
                         ),
                      ],
                   )
                ),
             ),
             
             const SizedBox(height: 48),
             Align(
                alignment: Alignment.centerRight,
                child: FilledButton.icon(
                   onPressed: _isSaving ? null : _saveSettings,
                   icon: _isSaving 
                      ? const SizedBox(width: 18, height: 18, child: CommandLoader(fullScreen: false)) 
                      : const Icon(Icons.save_outlined, size: 18),
                   label: const Text('SYNC NEURAL CONFIG'),
                   style: FilledButton.styleFrom(
                     padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 18),
                   ),
                ),
             )
          ],
        ),
      ),
    );
  }
}
