import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:api_sniper_labs/core/theme/app_colors.dart';
import 'package:api_sniper_labs/core/theme/app_text_styles.dart';
import 'package:api_sniper_labs/core/theme/app_spacing.dart';
import 'package:api_sniper_labs/core/widgets/command_loader.dart';
import 'package:api_sniper_labs/core/widgets/app_error.dart';
import 'package:api_sniper_labs/features/endpoints/presentation/bloc/endpoints_bloc.dart';
import 'package:api_sniper_labs/features/endpoints/domain/entities/api_endpoint.dart';
import 'package:api_sniper_labs/features/projects/presentation/bloc/projects_bloc.dart';
import 'package:api_sniper_labs/features/projects/presentation/widgets/endpoint_list.dart';

class ProjectEndpointsPage extends StatefulWidget {
  final String projectId;

  const ProjectEndpointsPage({super.key, required this.projectId});

  @override
  State<ProjectEndpointsPage> createState() => _ProjectEndpointsPageState();
}

class _ProjectEndpointsPageState extends State<ProjectEndpointsPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    context.read<EndpointsBloc>().add(LoadEndpointsRequested(projectId: widget.projectId));
    context.read<ProjectsBloc>().add(LoadProjectByIdRequested(id: widget.projectId));
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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
        title: BlocBuilder<ProjectsBloc, ProjectsState>(
          builder: (context, state) {
            String title = 'PROJECT ENDPOINTS';
            if (state is SingleProjectLoaded) {
              title = state.project.name.toUpperCase();
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.sectionTitle.copyWith(fontSize: 16, color: AppColors.primaryAccent),
                ),
                Text(
                  'PROJECT ENDPOINTS',
                  style: AppTextStyles.caption.copyWith(fontSize: 10, fontWeight: FontWeight.bold),
                ),
              ],
            );
          },
        ),
      ),
      body: BlocBuilder<ProjectsBloc, ProjectsState>(
        builder: (context, projectState) {
          if (projectState is ProjectsLoading) {
            return const CommandLoader(message: 'Retrieving project tactical records...');
          }

          if (projectState is ProjectsError) {
            return AppError(
              message: projectState.message,
              onRetry: () => context.read<ProjectsBloc>().add(LoadProjectByIdRequested(id: widget.projectId)),
            );
          }

          return BlocBuilder<EndpointsBloc, EndpointsState>(
            builder: (context, state) {
              if (state is EndpointsLoading) {
                return const CommandLoader(message: 'Retrieving all tactical endpoints...');
              } else if (state is EndpointsError) {
                return AppError(
                  message: state.message,
                  onRetry: () => context.read<EndpointsBloc>().add(LoadEndpointsRequested(projectId: widget.projectId)),
                );
              } else if (state is EndpointsLoaded) {
                final filteredEndpoints = state.endpoints.where((e) {
                  final query = _searchQuery.toLowerCase();
                  return e.path.toLowerCase().contains(query) || e.method.toLowerCase().contains(query) || e.description.toLowerCase().contains(query);
                }).toList();

                return Padding(
                  padding: AppSpacing.screenPadding,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSearchHeader(context),
                      const SizedBox(height: 32),
                      Expanded(
                        child: filteredEndpoints.isEmpty 
                          ? _buildEmptyState()
                          : SingleChildScrollView(
                              child: EndpointListWidget(
                                endpoints: filteredEndpoints,
                                projectId: widget.projectId,
                                showAnalysisButton: false,
                              ),
                            ),
                      ),
                    ],
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          );
        },
      ),
    );
  }

  Widget _buildSearchHeader(BuildContext context) {
    return Container(
      padding: AppSpacing.cardInsets,
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          const Icon(Icons.search, color: AppColors.primaryAccent),
          const SizedBox(width: 16),
          Expanded(
            child: TextField(
              controller: _searchController,
              onChanged: (value) => setState(() => _searchQuery = value),
              style: AppTextStyles.bodyText,
              decoration: InputDecoration(
                hintText: 'SEARCH ENDPOINTS BY PATH, METHOD OR DESCRIPTION...',
                hintStyle: AppTextStyles.caption.copyWith(color: AppColors.textSecondary.withOpacity(0.5)),
                border: InputBorder.none,
              ),
            ),
          ),
          if (_searchQuery.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear, size: 18),
              onPressed: () {
                _searchController.clear();
                setState(() => _searchQuery = '');
              },
            ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.search_off, size: 64, color: AppColors.textSecondary),
          const SizedBox(height: 16),
          Text(
            'NO ENDPOINTS MATCHING YOUR SEARCH CRITERIA.',
            style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
