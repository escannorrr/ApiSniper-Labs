import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:api_sniper_labs/core/theme/app_colors.dart';
import 'package:api_sniper_labs/core/theme/app_text_styles.dart';
import 'package:api_sniper_labs/core/theme/app_spacing.dart';
import 'package:api_sniper_labs/features/endpoints/domain/entities/api_endpoint.dart';

class EndpointListWidget extends StatelessWidget {
  final List<ApiEndpoint> endpoints;
  final String? projectId;
  final bool showAnalysisButton;

  const EndpointListWidget({
    super.key, 
    required this.endpoints, 
    this.projectId,
    this.showAnalysisButton = true,
  });

  @override
  Widget build(BuildContext context) {
    if (endpoints.isEmpty) {
      return Container(
         alignment: Alignment.center,
         padding: const EdgeInsets.all(32.0),
         child: Text(
           'NO ENDPOINTS DETECTED. UPLOAD SPECIFICATION TO INITIALIZE SCAN.', 
           style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.bold, letterSpacing: 1),
           textAlign: TextAlign.center,
         ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: endpoints.length,
      itemBuilder: (context, index) {
        final endpoint = endpoints[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: AppColors.sidebarBackground.withOpacity(0.5),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.border),
          ),
          child: Theme(
             data: Theme.of(context).copyWith(
               dividerColor: Colors.transparent,
               hoverColor: AppColors.primaryAccent.withOpacity(0.05),
             ),
             child: ExpansionTile(
              leading: _buildMethodBadge(endpoint.method),
              title: Text(
                endpoint.path, 
                style: AppTextStyles.bodyText.copyWith(
                  fontWeight: FontWeight.bold, 
                  fontFamily: 'monospace',
                  color: AppColors.textPrimary,
                ),
              ),
              subtitle: Text(
                endpoint.description.toUpperCase(), 
                style: AppTextStyles.caption.copyWith(fontSize: 10),
                maxLines: 1, 
                overflow: TextOverflow.ellipsis,
              ),
              iconColor: AppColors.primaryAccent,
              collapsedIconColor: AppColors.textSecondary,
              childrenPadding: const EdgeInsets.all(20.0),
              expandedCrossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Divider(color: AppColors.border),
                const SizedBox(height: 16),
                Text(
                  'MISSION PARAMETERS', 
                  style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.bold, color: AppColors.primaryAccent, letterSpacing: 1),
                ),
                const SizedBox(height: 12),
                if (endpoint.parameters.isEmpty)
                   Text(
                     'NO PARAMETERS LOGGED.', 
                     style: AppTextStyles.caption.copyWith(fontStyle: FontStyle.italic),
                   )
                else
                   ...endpoint.parameters.map((p) => Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Row(
                         children: [
                            const Icon(Icons.subdirectory_arrow_right, size: 14, color: AppColors.textSecondary),
                            const SizedBox(width: 8),
                            Text(
                              p.name, 
                              style: AppTextStyles.bodyText.copyWith(fontWeight: FontWeight.bold, fontFamily: 'monospace', fontSize: 13),
                            ),
                            const SizedBox(width: 12),
                            Container(
                               padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                               decoration: BoxDecoration(
                                 color: AppColors.border, 
                                 borderRadius: BorderRadius.circular(4),
                                 border: Border.all(color: AppColors.textSecondary.withOpacity(0.2)),
                               ),
                               child: Text(
                                 p.type.toUpperCase(), 
                                 style: AppTextStyles.caption.copyWith(fontSize: 10, fontWeight: FontWeight.bold),
                               ),
                            ),
                            if (p.isRequired)
                               Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Text(
                                    '* REQUIRED', 
                                    style: AppTextStyles.caption.copyWith(color: AppColors.error, fontSize: 10, fontWeight: FontWeight.bold),
                                  ),
                               )
                         ]
                      ),
                   )),
                   
                       if (showAnalysisButton)
                         const SizedBox(height: 24),
                       if (showAnalysisButton)
                         Align(
                           alignment: Alignment.centerRight,
                           child: OutlinedButton.icon(
                             onPressed: projectId == null ? null : () => context.go('/project/$projectId/endpoints'),
                             icon: const Icon(Icons.radar_outlined, size: 16),
                             label: const Text('FULL SPECTRUM ANALYSIS'),
                             style: OutlinedButton.styleFrom(
                               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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

  Widget _buildMethodBadge(String method) {
    Color color;
    switch (method.toUpperCase()) {
      case 'GET': color = AppColors.secondaryAccent; break;
      case 'POST': color = AppColors.primaryAccent; break;
      case 'PUT': color = AppColors.warning; break;
      case 'DELETE': color = AppColors.error; break;
      case 'PATCH': color = Colors.purpleAccent; break;
      default: color = AppColors.textSecondary;
    }

    return Container(
      width: 70,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        border: Border.all(color: color.withOpacity(0.5)),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        method.toUpperCase(),
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
