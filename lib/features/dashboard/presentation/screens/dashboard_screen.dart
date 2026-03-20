import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../bloc/dashboard_bloc.dart';
import '../widgets/stat_card.dart';
import '../widgets/quality_score_card.dart';
import '../../../../core/widgets/command_loader.dart';
import '../../../../core/widgets/command_empty_state.dart';
import '../../../../core/widgets/app_error.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_spacing.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    context.read<DashboardBloc>().add(DashboardLoadRequested());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardBloc, DashboardState>(
      builder: (context, state) {
        if (state is DashboardLoading) {
          return const CommandLoader(message: 'Initializing tactical overview...');
        } else if (state is DashboardFailure) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, color: AppColors.error, size: 48),
                const SizedBox(height: 16),
                Text('SYSTEM ERROR: ${state.message}',
                    style: AppTextStyles.bodyText.copyWith(color: AppColors.error)),
              ],
            ),
          );
        } else if (state is DashboardLoaded) {
          return _buildDashboardContent(context, state);
        }
        return const CommandEmptyState(message: 'No tactical data available in this sector.');
      },
    );
  }

  Widget _buildDashboardContent(BuildContext context, DashboardLoaded state) {
    return SingleChildScrollView(
      padding: AppSpacing.screenPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'TACTICAL COMMAND CENTER',
                    style: AppTextStyles.pageTitle.copyWith(
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'OPERATOR: DEVELOPER_01 // SECURE SESSION ACTIVE',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.primaryAccent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.primaryAccent.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: AppColors.primaryAccent.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.circle, color: AppColors.primaryAccent, size: 8),
                    const SizedBox(width: 8),
                    Text(
                      'SYSTEM ONLINE',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.primaryAccent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 48),
          Wrap(
            spacing: 24,
            runSpacing: 24,
            children: [
              StatCard(
                title: 'Total Projects',
                value: state.statistics['totalProjects'].toString().padLeft(3, '0'),
                icon: Icons.folder_copy_outlined,
                baseColor: AppColors.secondaryAccent,
              ),
              StatCard(
                title: 'Endpoints Analyzed',
                value: state.statistics['totalEndpointsTested'].toString().padLeft(3, '0'),
                icon: Icons.api_outlined,
                baseColor: AppColors.secondaryAccent,
              ),
              StatCard(
                title: 'Avg Quality Score',
                value: '${state.statistics['averageQualityScore']}%',
                icon: Icons.health_and_safety_outlined,
                baseColor: AppColors.primaryAccent,
              ),
              StatCard(
                title: 'Security Criticals',
                value: state.statistics['openSecurityCriticals'].toString().padLeft(2, '0'),
                icon: Icons.gpp_bad_outlined,
                baseColor: AppColors.error,
              ),
            ],
          ),
          const SizedBox(height: 32),
          QualityScoreCard(
            overallScore: state.statistics['averageQualityScore'] ?? 85,
            functionalScore: 92,
            securityScore: 78,
            edgeCaseScore: 65,
            performanceScore: 95,
          ),
          const SizedBox(height: 48),
          Text(
            'RECENT PROJECT DISPATCHES',
            style: AppTextStyles.sectionTitle.copyWith(
              letterSpacing: 1.5,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              color: AppColors.cardBackground,
              borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
              border: Border.all(color: AppColors.border, width: 1),
            ),
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: state.projects.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final project = state.projects[index];
                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.sidebarBackground,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: const Icon(Icons.api, color: AppColors.secondaryAccent),
                  ),
                  title: Text(
                    project.name, 
                    style: AppTextStyles.bodyText.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  subtitle: Text(
                    'LAST SCAN: ${project.lastAnalyzed.toString().split('.')[0]}',
                    style: AppTextStyles.caption,
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildScoreBadge(project.overallScore),
                      const SizedBox(width: 16),
                      const Icon(Icons.chevron_right, color: AppColors.textSecondary),
                    ],
                  ),
                  onTap: () {
                     context.push('/project/${project.id}');
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _buildScoreBadge(int score) {
    Color color = AppColors.primaryAccent;
    if (score < 70) {
      color = AppColors.error;
    } else if (score < 90) {
      color = AppColors.warning;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        'Q-SCORE: $score',
        style: AppTextStyles.caption.copyWith(
          color: color,
          fontWeight: FontWeight.bold,
          fontFamily: 'monospace',
        ),
      ),
    );
  }
}

