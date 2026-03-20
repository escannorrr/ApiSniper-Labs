import '../../../../core/network/api_client.dart';
import '../models/security_model.dart';

abstract class SecurityRemoteDataSource {
  Future<List<SecurityModel>> getSecurityIssues(String projectId);
}

class SecurityRemoteDataSourceImpl implements SecurityRemoteDataSource {
  final ApiClient apiClient;

  SecurityRemoteDataSourceImpl(this.apiClient);

  @override
  Future<List<SecurityModel>> getSecurityIssues(String projectId) async {
    final response = await apiClient.post('/projects/$projectId/security-analysis');
    return (response.data as List)
        .map((json) => SecurityModel.fromJson(json))
        .toList();
  }
}
