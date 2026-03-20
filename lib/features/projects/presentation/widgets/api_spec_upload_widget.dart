import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:api_sniper_labs/features/projects/presentation/bloc/projects_bloc.dart';
import 'package:api_sniper_labs/features/projects/presentation/bloc/api_spec_bloc.dart';
import 'package:api_sniper_labs/features/projects/presentation/bloc/api_spec_event.dart';
import 'package:api_sniper_labs/features/projects/presentation/bloc/api_spec_state.dart';
import 'package:api_sniper_labs/core/theme/app_colors.dart';
import 'package:api_sniper_labs/core/theme/app_text_styles.dart';
import 'package:api_sniper_labs/core/theme/app_spacing.dart';
import 'package:api_sniper_labs/core/widgets/command_loader.dart';
import 'package:api_sniper_labs/core/widgets/command_snackbar.dart';

class ApiSpecUploadWidget extends StatefulWidget {
  final String projectId;

  const ApiSpecUploadWidget({super.key, required this.projectId});

  @override
  State<ApiSpecUploadWidget> createState() => _ApiSpecUploadWidgetState();
}

class _ApiSpecUploadWidgetState extends State<ApiSpecUploadWidget> {
  final _urlController = TextEditingController();
  final _jsonController = TextEditingController();

  @override
  void dispose() {
    _urlController.dispose();
    _jsonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final projectRepository = context.read<ProjectsBloc>().repository;
        return ApiSpecBloc(repository: projectRepository);
      },
      child: BlocConsumer<ApiSpecBloc, ApiSpecState>(
        listener: (context, state) {
          if (state is ApiSpecError) {
             ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message), backgroundColor: AppColors.error));
          } else if (state is ApiSpecParsed) {
             if (state.successMessage != null) {
                 ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.successMessage!), backgroundColor: AppColors.primaryAccent));
             }
          }
        },
        builder: (context, state) {
           return Container(
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
                   Row(
                      children: [
                         const Icon(Icons.satellite_alt_outlined, color: AppColors.primaryAccent, size: 20),
                         const SizedBox(width: 12),
                         Text(
                            'API SPECIFICATION INGESTION',
                            style: AppTextStyles.sectionTitle.copyWith(letterSpacing: 1.2),
                         ),
                      ],
                   ),
                   const SizedBox(height: 16),
                   Text(
                     'UPLOADING OR REPLACING THE MISSION SPECIFICATION (OPENAPI / POSTMAN / SWAGGER).', 
                     style: AppTextStyles.caption.copyWith(fontSize: 10),
                   ),
                   const SizedBox(height: 32),
                   
                   if (state is ApiSpecUploading)
                      const SizedBox(
                        height: 250,
                        child: Center(child: CommandLoader(message: 'INGESTING DATA STREAMS...', fullScreen: false)),
                      )
                   else
                      DefaultTabController(
                        length: 3,
                        child: Column(
                          children: [
                            TabBar(
                              indicatorColor: AppColors.primaryAccent,
                              labelColor: AppColors.primaryAccent,
                              unselectedLabelColor: AppColors.textSecondary,
                              labelStyle: AppTextStyles.caption.copyWith(fontWeight: FontWeight.bold),
                              tabs: const [
                                Tab(icon: Icon(Icons.file_upload_outlined, size: 18), text: 'FILE_UPLOAD'),
                                Tab(icon: Icon(Icons.code_outlined, size: 18), text: 'PASTE_JSON'),
                                Tab(icon: Icon(Icons.lan_outlined, size: 18), text: 'REMOTE_URL'),
                              ],
                            ),
                            const SizedBox(height: 24),
                            SizedBox(
                              height: 220,
                              child: TabBarView(
                                children: [
                                  // Tab 1: File Upload
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(Icons.cloud_upload_outlined, size: 48, color: AppColors.textSecondary),
                                      const SizedBox(height: 16),
                                      FilledButton.icon(
                                        onPressed: () {
                                           context.read<ApiSpecBloc>().add(UploadSpecFile(widget.projectId));
                                        },
                                        icon: const Icon(Icons.attach_file, size: 18),
                                        label: const Text('SELECT LOCAL ARCHIVE'),
                                      ),
                                    ],
                                  ),
                                  
                                  // Tab 2: Paste JSON
                                  Column(
                                    children: [
                                      Expanded(
                                        child: TextField(
                                          controller: _jsonController,
                                          maxLines: null,
                                          expands: true,
                                          style: AppTextStyles.codeText.copyWith(fontSize: 12),
                                          decoration: InputDecoration(
                                            hintText: 'PASTE RAW DATA BLOCK HERE...',
                                            hintStyle: AppTextStyles.caption.copyWith(color: AppColors.textSecondary.withOpacity(0.5)),
                                            border: const OutlineInputBorder(),
                                            filled: true,
                                            fillColor: AppColors.sidebarBackground.withOpacity(0.5),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: FilledButton.icon(
                                           onPressed: () {
                                              context.read<ApiSpecBloc>().add(PasteSpecJson(widget.projectId, _jsonController.text));
                                           },
                                           icon: const Icon(Icons.terminal_outlined, size: 18),
                                           label: const Text('PARSING DATA'),
                                        ),
                                      )
                                    ],
                                  ),
                                  
                                  // Tab 3: Import URL
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                       TextField(
                                          controller: _urlController,
                                          style: AppTextStyles.bodyText,
                                          decoration: const InputDecoration(
                                            labelText: 'REMOTE ENDPOINT URL',
                                            hintText: 'https://api.vault.com/v1/swagger.json',
                                            prefixIcon: Icon(Icons.link, size: 18),
                                          ),
                                        ),
                                        const SizedBox(height: 24),
                                        FilledButton.icon(
                                           onPressed: () {
                                              context.read<ApiSpecBloc>().add(ImportSpecFromUrl(widget.projectId, _urlController.text));
                                           },
                                           icon: const Icon(Icons.downloading_outlined, size: 18),
                                           label: const Text('INITIALIZE REMOTE SYNC'),
                                        )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
