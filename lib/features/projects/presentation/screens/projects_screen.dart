import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:api_sniper_labs/features/projects/presentation/bloc/projects_bloc.dart';
import 'package:api_sniper_labs/features/billing/presentation/bloc/billing_bloc.dart';
import 'package:api_sniper_labs/core/widgets/command_loader.dart';
import 'package:api_sniper_labs/core/widgets/command_empty_state.dart';
import 'package:api_sniper_labs/core/widgets/command_snackbar.dart';
import 'package:api_sniper_labs/core/widgets/app_error.dart';
import 'package:api_sniper_labs/core/theme/app_colors.dart';
import 'package:api_sniper_labs/core/theme/app_text_styles.dart';
import 'package:api_sniper_labs/core/theme/app_spacing.dart';

class ProjectsScreen extends StatefulWidget {
  const ProjectsScreen({super.key});

  @override
  State<ProjectsScreen> createState() => _ProjectsScreenState();
}

class _ProjectsScreenState extends State<ProjectsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ProjectsBloc>().add(LoadProjectsRequested());
    context.read<BillingBloc>().add(LoadBillingDataRequested());
  }

  void _showCreateProjectModal(BuildContext context) {
    // Check usage limits
    final billingState = context.read<BillingBloc>().state;
    final projectsState = context.read<ProjectsBloc>().state;

    if (billingState is BillingDataLoaded && projectsState is ProjectsLoaded) {
      final currentPlan = billingState.plans.firstWhere(
        (p) => p.id == billingState.currentSubscription.planId, 
        orElse: () => billingState.plans.first
      );
      
      if (projectsState.projects.length >= currentPlan.maxProjects) {
        _showUpgradeDialog(context);
        return;
      }
    }

    final nameController = TextEditingController();
    final descController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: AppColors.cardBackground,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: const BorderSide(color: AppColors.border)),
          title: Text('GENERATE NEW PROJECT', style: AppTextStyles.sectionTitle.copyWith(letterSpacing: 1.5)),
          content: SizedBox(
            width: 500,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('PROJECT IDENTITY', style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.bold, color: AppColors.primaryAccent)),
                const SizedBox(height: 12),
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'NAME',
                    hintText: 'e.g., CORE_API_V1',
                  ),
                ),
                const SizedBox(height: 24),
                Text('MISSION PARAMETERS', style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.bold, color: AppColors.primaryAccent)),
                const SizedBox(height: 12),
                TextField(
                  controller: descController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'DESCRIPTION',
                    hintText: 'Detail the operational scope...',
                  ),
                ),
              ],
            ),
          ),
          actions: [
            OutlinedButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('ABORT'),
            ),
            FilledButton(
              onPressed: () {
                if (nameController.text.isNotEmpty) {
                  context.read<ProjectsBloc>().add(
                        CreateProjectRequested(
                          name: nameController.text,
                          description: descController.text,
                        ),
                      );
                  Navigator.of(dialogContext).pop();
                }
              },
              child: const Text('INITIALIZE'),
            ),
          ],
        );
      },
    );
  }

  void _showUpgradeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.cardBackground,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: const BorderSide(color: AppColors.warning)),
        title: Row(
          children: [
            const Icon(Icons.workspace_premium, color: AppColors.warning),
            const SizedBox(width: 12),
            Text('RESTRICTED ACCESS', style: AppTextStyles.sectionTitle.copyWith(color: AppColors.warning)),
          ],
        ),
        content: const Text('Operational capacity reached. Security clearance upgrade required to deploy additional projects.'),
        actions: [
          OutlinedButton(
            onPressed: () => Navigator.pop(ctx), 
            child: const Text('CANCEL')
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppColors.warning),
            onPressed: () {
              Navigator.pop(ctx);
              context.go('/pricing');
            },
            child: const Text('UPGRADE CLEARANCE'),
          ),
        ],
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: AppSpacing.screenPadding.copyWith(bottom: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
               Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                   Text(
                     'PROJECT DEPLOYMENTS', 
                     style: AppTextStyles.pageTitle.copyWith(letterSpacing: 2),
                   ),
                   const SizedBox(height: 4),
                   Text(
                     'ACTIVE OPERATIONS IN SECTOR',
                     style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.bold),
                   ),
                 ],
               ),
               FilledButton.icon(
                 onPressed: () => _showCreateProjectModal(context),
                 icon: const Icon(Icons.add_moderator),
                 label: const Text('NEW PROJECT'),
               ),
            ],
          ),
        ),
        Expanded(
          child: BlocConsumer<ProjectsBloc, ProjectsState>(
            listener: (context, state) {
              if (state is ProjectOperationSuccess) {
                CommandSnackbar.showSuccess(context, state.message);
              } else if (state is ProjectsError) {
                CommandSnackbar.showError(context, state.message);
              }
            },
            builder: (context, state) {
              if (state is ProjectsLoading) {
                return const CommandLoader(message: 'Gathering project intelligence...');
              } else if (state is ProjectsError) {
                return AppError(
                  message: state.message,
                  onRetry: () => context.read<ProjectsBloc>().add(LoadProjectsRequested()),
                );
              } else if (state is ProjectsLoaded) {
                if (state.projects.isEmpty) {
                  return CommandEmptyState(
                    message: 'No project operations deployed in this sector.',
                    actionLabel: 'Deploy New Project',
                    onAction: () => _showCreateProjectModal(context),
                  );
                }

                return GridView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 450,
                    mainAxisExtent: 240,
                    crossAxisSpacing: 24,
                    mainAxisSpacing: 24,
                  ),
                  itemCount: state.projects.length,
                  itemBuilder: (context, index) {
                    final project = state.projects[index];
                    return Container(
                      decoration: BoxDecoration(
                        color: AppColors.cardBackground,
                        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
                        border: Border.all(color: AppColors.border, width: 1),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: InkWell(
                        onTap: () {
                          context.push('/project/${project.id}');
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: AppColors.sidebarBackground,
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(color: AppColors.border),
                                    ),
                                    child: const Icon(Icons.shield_outlined, color: AppColors.primaryAccent, size: 18),
                                  ),
                                  const Spacer(),
                                  _buildScoreBadge(project.overallScore),
                                  const SizedBox(width: 8),
                                  PopupMenuButton<String>(
                                    icon: const Icon(Icons.more_vert, color: AppColors.textSecondary),
                                    onSelected: (value) {
                                      if (value == 'delete') {
                                        context.read<ProjectsBloc>().add(DeleteProjectRequested(id: project.id));
                                      }
                                    },
                                    itemBuilder: (context) => [
                                      const PopupMenuItem(
                                        value: 'edit',
                                        child: Text('TERMINAL SETTINGS'),
                                      ),
                                      const PopupMenuItem(
                                        value: 'delete',
                                        child: Text('DELETE PROJECT', style: TextStyle(color: AppColors.error)),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              Text(
                                project.name.toUpperCase(),
                                style: AppTextStyles.bodyText.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                  letterSpacing: 1.2,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                project.description,
                                style: AppTextStyles.caption.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const Spacer(),
                              const Divider(height: 1),
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(Icons.bolt, size: 14, color: AppColors.secondaryAccent),
                                      const SizedBox(width: 4),
                                      Text(
                                        '${project.endpointCount} ENDPOINTS',
                                        style: AppTextStyles.caption.copyWith(
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'monospace',
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    'SPEC: V${project.openApiVersion}',
                                    style: AppTextStyles.caption.copyWith(
                                      color: AppColors.primaryAccent,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'monospace',
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ],
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
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        'Q-$score',
        style: AppTextStyles.caption.copyWith(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 10,
          fontFamily: 'monospace',
        ),
      ),
    );
  }
}
