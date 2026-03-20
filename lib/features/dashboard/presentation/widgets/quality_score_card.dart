import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_spacing.dart';

class QualityScoreCard extends StatelessWidget {
  final int overallScore;
  final int functionalScore;
  final int securityScore;
  final int edgeCaseScore;
  final int performanceScore;

  const QualityScoreCard({
    super.key,
    required this.overallScore,
    required this.functionalScore,
    required this.securityScore,
    required this.edgeCaseScore,
    required this.performanceScore,
  });

  Color _getScoreColor(int score) {
    if (score >= 90) return AppColors.primaryAccent;
    if (score >= 70) return AppColors.warning;
    return AppColors.error;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppSpacing.cardInsets,
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        border: Border.all(color: AppColors.border, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.analytics_outlined, color: AppColors.primaryAccent, size: 20),
              const SizedBox(width: 12),
              Text(
                'API QUALITY ANALYSIS BREAKDOWN',
                style: AppTextStyles.sectionTitle.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 130,
                          height: 130,
                          child: CircularProgressIndicator(
                            value: overallScore / 100,
                            strokeWidth: 10,
                            color: _getScoreColor(overallScore),
                            backgroundColor: AppColors.border,
                            strokeCap: StrokeCap.round,
                          ),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '$overallScore',
                              style: AppTextStyles.pageTitle.copyWith(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: _getScoreColor(overallScore),
                                fontFamily: 'monospace',
                              ),
                            ),
                            Text(
                              'INDEX',
                              style: AppTextStyles.caption.copyWith(
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'OVERALL READINESS',
                      style: AppTextStyles.caption.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 48),
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    _buildProgressBarRow(context, 'FUNCTIONAL TESTS', functionalScore),
                    const SizedBox(height: 20),
                    _buildProgressBarRow(context, 'SECURITY SCAN', securityScore),
                    const SizedBox(height: 20),
                    _buildProgressBarRow(context, 'EDGE CASE COVERAGE', edgeCaseScore),
                    const SizedBox(height: 20),
                    _buildProgressBarRow(context, 'PERFORMANCE SCALE', performanceScore),
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBarRow(BuildContext context, String title, int score) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: AppTextStyles.caption.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 10,
                letterSpacing: 1,
              ),
            ),
            Text(
              '$score%',
              style: AppTextStyles.caption.copyWith(
                fontWeight: FontWeight.bold,
                color: _getScoreColor(score),
                fontFamily: 'monospace',
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: score / 100,
            color: _getScoreColor(score),
            backgroundColor: AppColors.border,
            minHeight: 6,
          ),
        ),
      ],
    );
  }
}
