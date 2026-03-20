import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:api_sniper_labs/features/projects/presentation/bloc/projects_bloc.dart';
import 'package:api_sniper_labs/features/projects/presentation/bloc/api_spec_bloc.dart';
import 'package:api_sniper_labs/features/projects/presentation/bloc/api_spec_event.dart';
import 'package:api_sniper_labs/features/projects/presentation/bloc/api_spec_state.dart';
import 'package:api_sniper_labs/features/billing/presentation/bloc/billing_bloc.dart';
import 'package:api_sniper_labs/features/test_generation/presentation/bloc/test_generation_bloc.dart';
import 'package:api_sniper_labs/features/test_generation/domain/models/test_language.dart';
import 'package:api_sniper_labs/features/test_generation/presentation/widgets/test_language_selector.dart';
import 'package:api_sniper_labs/features/projects/presentation/widgets/endpoint_list.dart';
import 'package:api_sniper_labs/features/projects/presentation/widgets/api_spec_upload_widget.dart';
import 'package:api_sniper_labs/core/widgets/command_loader.dart';
import 'package:api_sniper_labs/core/widgets/command_empty_state.dart';
import 'package:api_sniper_labs/core/widgets/app_error.dart';
import 'package:api_sniper_labs/core/widgets/code_viewer.dart';
import 'package:api_sniper_labs/core/theme/app_colors.dart';
import 'package:api_sniper_labs/core/theme/app_text_styles.dart';
import 'package:api_sniper_labs/core/theme/app_spacing.dart';

class ProjectDetailsPage extends StatefulWidget {
  final String projectId;

  const ProjectDetailsPage({super.key, required this.projectId});

  @override
  State<ProjectDetailsPage> createState() => _ProjectDetailsPageState();
}

class _ProjectDetailsPageState extends State<ProjectDetailsPage> {
  @override
  void initState() {
    super.initState();
    context.read<BillingBloc>().add(LoadBillingDataRequested());
  }

  void _handleGenerate(BuildContext context) {
    final testState = context.read<TestGenerationBloc>().state;
    context.read<TestGenerationBloc>().add(
          GenerateTestsRequested(
            projectId: widget.projectId,
            language: testState.selectedLanguage.id,
          ),
        );
  }

  String billingSubscriptionPlanId(BuildContext context, BillingDataLoaded state) {
      return state.currentSubscription.planId;
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) {
            final projectRepository = context.read<ProjectsBloc>().repository;
            return ApiSpecBloc(repository: projectRepository)
              ..add(LoadEndpointsRequested(widget.projectId));
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: AppColors.primaryBackground,
        appBar: AppBar(
          title: Text('MISSION WORKSPACE: ${widget.projectId.toUpperCase()}', style: AppTextStyles.sectionTitle.copyWith(fontSize: 14)),
        ),
        body: Builder(
          builder: (context) {
            return SingleChildScrollView(
              padding: AppSpacing.screenPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(context),
                  const SizedBox(height: 48),
                  ApiSpecUploadWidget(projectId: widget.projectId),
                  const SizedBox(height: 48),
                  _buildEndpointsSection(context),
                  const SizedBox(height: 48),
                  _buildTestGenerationSection(context),
                  const SizedBox(height: 48),
                  _buildSecurityPlaceholder(context),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: AppSpacing.cardInsets,
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
                color: AppColors.sidebarBackground,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.primaryAccent.withOpacity(0.3))),
            child: const Icon(Icons.terminal, size: 40, color: AppColors.primaryAccent),
          ),
          const SizedBox(width: 24),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'OPERATIONAL CONTEXT',
                  style: AppTextStyles.sectionTitle.copyWith(letterSpacing: 1.2),
                ),
                const SizedBox(height: 8),
                Text(
                  'DEPLOYMENT_ID: ${widget.projectId}', 
                  style: AppTextStyles.caption.copyWith(fontFamily: 'monospace', color: AppColors.secondaryAccent),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          FilledButton.icon(
            onPressed: () {
              context.read<ApiSpecBloc>().add(UploadSpecFile(widget.projectId));
            },
            icon: const Icon(Icons.cloud_upload_outlined),
            label: const Text('UPLOAD SPEC'),
          ),
        ],
      ),
    );
  }

  Widget _buildEndpointsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(Icons.api, color: AppColors.primaryAccent, size: 20),
                const SizedBox(width: 12),
                Text(
                  'DISCOVERED ENDPOINTS',
                  style: AppTextStyles.sectionTitle.copyWith(letterSpacing: 1.1),
                ),
              ],
            ),
            TextButton.icon(
              onPressed: () => context.push('/project/${widget.projectId}/endpoints'),
              icon: const Icon(Icons.visibility_outlined, size: 16),
              label: const Text('VIEW ALL'),
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primaryAccent,
                textStyle: AppTextStyles.caption.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        BlocBuilder<ApiSpecBloc, ApiSpecState>(
          builder: (context, state) {
            final allEndpoints = (state is ApiSpecParsed) ? state.endpoints : (state is EndpointsLoaded) ? state.endpoints : [];
            final previewEndpoints = allEndpoints.take(5).toList();
            return Container(
              decoration: BoxDecoration(
                color: AppColors.cardBackground,
                borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
                border: Border.all(color: AppColors.border),
              ),
              child: EndpointListWidget(endpoints: previewEndpoints.cast(), projectId: widget.projectId),
            );
          },
        ),
      ],
    );
  }

  Widget _buildTestGenerationSection(BuildContext context) {
    return BlocBuilder<TestGenerationBloc, TestGenerationState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.auto_awesome_outlined, color: AppColors.primaryAccent, size: 20),
                    const SizedBox(width: 12),
                    Text(
                      'AI TACTICAL TEST GENERATION',
                      style: AppTextStyles.sectionTitle.copyWith(letterSpacing: 1.1),
                    ),
                  ],
                ),
                FilledButton.icon(
                  onPressed: state is TestGenerationLoading ? null : () => _handleGenerate(context),
                  icon: const Icon(Icons.precision_manufacturing_outlined),
                  label: const Text('GENERATE TESTS'),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Container(
              width: 300,
              child: TestLanguageSelector(
                selectedLanguage: state.selectedLanguage,
                onChanged: (lang) {
                  if (lang != null) {
                    context.read<TestGenerationBloc>().add(ChangeTestLanguage(lang));
                  }
                },
              ),
            ),
            const SizedBox(height: 24),
            _buildTestContent(context, state),
          ],
        );
      },
    );
  }

  Widget _buildTestContent(BuildContext context, TestGenerationState state) {
    if (state is TestGenerationLoading) {
      return Container(
        height: 200,
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
          border: Border.all(color: AppColors.border),
        ),
        child: const Center(child: CommandLoader(message: 'Synthesizing test cases...', fullScreen: false)),
      );
    }
    if (state is TestGenerationFailure) {
      return AppError(message: state.message, onRetry: () => _handleGenerate(context));
    }
    if (state is TestGenerationSuccess) {
      final test = state.test;
      return Container(
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
          border: Border.all(color: AppColors.border),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  const Icon(Icons.code, size: 20, color: AppColors.primaryAccent),
                  const SizedBox(width: 12),
                  Text(
                    'GENERATED_${state.selectedLanguage.name.toUpperCase()}: ${test.totalCases} VECTORS', 
                    style: AppTextStyles.bodyText.copyWith(fontWeight: FontWeight.bold, fontFamily: 'monospace'),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.copy, size: 18, color: AppColors.textSecondary), 
                    onPressed: () {},
                    tooltip: 'COPY CODE',
                  ),
                  IconButton(
                    icon: const Icon(Icons.download, size: 18, color: AppColors.textSecondary), 
                    onPressed: () {},
                    tooltip: 'DOWNLOAD .${state.selectedLanguage.fileExtension}',
                  ),
                  const SizedBox(width: 8),
                  FilledButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.play_arrow, size: 16),
                    label: const Text('EXECUTE'),
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      backgroundColor: AppColors.secondaryAccent,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
                SizedBox(
                  height: 450,
                  child: CodeViewer(code: test.code, language: state.selectedLanguage.highlightId),
                ),
          ],
        ),
      );
    }
    return CommandEmptyState(
      message: 'INITIALIZE TACTICAL TEST VECTORS USING AI ANALYSIS',
      actionLabel: 'READY SENSOR SCAN',
      onAction: () {},
    );
  }

  Widget _buildSecurityPlaceholder(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        border: Border.all(color: AppColors.border),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(24),
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.error.withOpacity(0.1),
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.error.withOpacity(0.3)),
          ),
          child: const Icon(Icons.gpp_maybe_outlined, color: AppColors.error, size: 28),
        ),
        title: Text(
          'SECURITY RECONNAISSANCE', 
          style: AppTextStyles.bodyText.copyWith(fontWeight: FontWeight.bold, letterSpacing: 1),
        ),
        subtitle: const Text('Perform deep vulnerability probes and compliance validation on target endpoints.'),
        trailing: OutlinedButton(
          onPressed: () => context.push('/project/${widget.projectId}/security'),
          child: const Text('ACCESS RADIUS'),
        ),
      ),
    );
  }
}
