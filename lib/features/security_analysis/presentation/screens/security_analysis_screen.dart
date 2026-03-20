import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../bloc/security_analysis_bloc.dart';
import '../../../../core/widgets/command_loader.dart';
import '../../../../core/widgets/command_empty_state.dart';
import '../../../../core/widgets/app_error.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_spacing.dart';

class SecurityAnalysisScreen extends StatefulWidget {
  final String? projectId;
  const SecurityAnalysisScreen({super.key, this.projectId});

  @override
  State<SecurityAnalysisScreen> createState() => _SecurityAnalysisScreenState();
}

class _SecurityAnalysisScreenState extends State<SecurityAnalysisScreen> {
  @override
  void initState() {
    super.initState();
    if (widget.projectId != null) {
      context.read<SecurityAnalysisBloc>().add(LoadSecurityIssuesRequested(projectId: widget.projectId!));
    }
  }

  Color _getSeverityColor(String severity) {
    switch (severity.toLowerCase()) {
      case 'high': return AppColors.error;
      case 'medium': return AppColors.warning;
      case 'low': return AppColors.secondaryAccent;
      default: return AppColors.textSecondary;
    }
  }

  IconData _getSeverityIcon(String severity) {
    switch (severity.toLowerCase()) {
      case 'high': return Icons.gpp_bad_outlined;
      case 'medium': return Icons.warning_amber_outlined;
      case 'low': return Icons.info_outline;
      default: return Icons.help_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/project/${widget.projectId}'),
        ),
        title: Text(
          'SECURITY RECONNAISSANCE',
          style: AppTextStyles.sectionTitle.copyWith(fontSize: 14),
        ),
        actions: [
          if (widget.projectId != null)
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: FilledButton.icon(
                onPressed: () => context.read<SecurityAnalysisBloc>().add(LoadSecurityIssuesRequested(projectId: widget.projectId!)),
                icon: const Icon(Icons.radar_outlined, size: 18),
                label: const Text('RESCAN'),
              ),
            ),
        ],
      ),
      body: BlocBuilder<SecurityAnalysisBloc, SecurityAnalysisState>(
        builder: (context, state) {
          if (state is SecurityAnalysisLoading) {
            return const CommandLoader(message: 'Infiltrating API architecture for deep-scan probe...');
          } else if (state is SecurityAnalysisError) {
            return AppError(
              message: state.message,
              onRetry: widget.projectId == null ? null : () => context.read<SecurityAnalysisBloc>().add(LoadSecurityIssuesRequested(projectId: widget.projectId!)),
            );
          } else if (state is SecurityAnalysisLoaded) {
            if (state.issues.isEmpty) {
              return const CommandEmptyState(
                message: 'SECTOR CLEAR: NO VULNERABILITY VECTORS DETECTED IN ACTIVE PROBE.',
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              itemCount: state.issues.length,
              itemBuilder: (context, index) {
                final issue = state.issues[index];
                final severityColor = _getSeverityColor(issue.severity);
                
                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: AppColors.cardBackground,
                    borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
                    border: Border.all(color: AppColors.border),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          width: 6,
                          color: severityColor,
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(_getSeverityIcon(issue.severity), color: severityColor, size: 24),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        issue.issueType.toUpperCase(),
                                        style: AppTextStyles.bodyText.copyWith(
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 1,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: severityColor.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(4),
                                        border: Border.all(color: severityColor.withOpacity(0.3)),
                                      ),
                                      child: Text(
                                        issue.severity.toUpperCase(),
                                        style: AppTextStyles.caption.copyWith(
                                          color: severityColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 10,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                  decoration: BoxDecoration(
                                    color: AppColors.sidebarBackground,
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(color: AppColors.border),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.api_outlined, size: 14, color: AppColors.textSecondary),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          issue.endpoint,
                                          style: AppTextStyles.codeText.copyWith(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.primaryAccent,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Text(
                                  'DETAILED INTELLIGENCE',
                                  style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.bold, letterSpacing: 1),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  issue.description,
                                  style: AppTextStyles.bodyText.copyWith(fontSize: 14, color: AppColors.textSecondary),
                                ),
                                const SizedBox(height: 20),
                                Text(
                                  'COUNTERMEASURE PROTOCOL',
                                  style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.bold, letterSpacing: 1, color: AppColors.primaryAccent),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  issue.recommendation, 
                                  style: AppTextStyles.bodyText.copyWith(fontSize: 14, fontStyle: FontStyle.italic),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
           return const SizedBox.shrink();
        },
      ),
    );
  }
}
