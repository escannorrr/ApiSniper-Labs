import 'package:flutter/material.dart';
import 'package:api_sniper_labs/core/theme/app_colors.dart';
import 'package:api_sniper_labs/core/theme/app_text_styles.dart';
import 'package:api_sniper_labs/features/test_generation/domain/models/test_language.dart';

class TestLanguageSelector extends StatelessWidget {
  final TestLanguage selectedLanguage;
  final ValueChanged<TestLanguage?> onChanged;

  const TestLanguageSelector({
    super.key,
    required this.selectedLanguage,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'TEST LANGUAGE',
          style: AppTextStyles.caption.copyWith(
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<TestLanguage>(
          value: selectedLanguage,
          dropdownColor: AppColors.sidebarBackground,
          style: AppTextStyles.bodyText,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            filled: true,
            fillColor: AppColors.sidebarBackground,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColors.primaryAccent),
            ),
          ),
          items: TestLanguage.supportedLanguages.map((lang) {
            return DropdownMenuItem(
              value: lang,
              child: Text(lang.displayName),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }
}
