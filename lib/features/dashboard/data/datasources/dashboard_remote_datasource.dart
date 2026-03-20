import '../../../../core/network/api_client.dart';
import '../../domain/entities/project_summary.dart';

abstract class DashboardRemoteDataSource {
  Future<List<ProjectSummary>> getProjects();
  Future<Map<String, dynamic>> getStatistics();
}

class DashboardRemoteDataSourceImpl implements DashboardRemoteDataSource {
  final ApiClient apiClient;

  DashboardRemoteDataSourceImpl(this.apiClient);

  @override
  Future<List<ProjectSummary>> getProjects() async {
    final response = await apiClient.get('/projects');
    final List<dynamic> projects = response.data;
    
    return projects.map((json) {
      return ProjectSummary(
        id: (json['id'] ?? '').toString(),
        name: json['name'] ?? '',
        endpointsCount: json['endpoint_count'] ?? 0,
        overallScore: 0, // Placeholder as score is not yet in the backend
        lastAnalyzed: DateTime.tryParse(json['updated_at'] ?? '') ?? 
                      DateTime.tryParse(json['created_at'] ?? '') ?? 
                      DateTime.now(),
        securityIssues: 0, // Placeholder
      );
    }).toList();
  }

  @override
  Future<Map<String, dynamic>> getStatistics() async {
    // For now, derive statistics from projects as the backend doesn't have a dedicated endpoint
    final projects = await getProjects();
    
    return {
      'totalProjects': projects.length,
      'totalEndpointsTested': projects.fold(0, (sum, p) => sum + p.endpointsCount),
      'averageQualityScore': 0,
      'openSecurityCriticals': 0,
    };
  }
}
