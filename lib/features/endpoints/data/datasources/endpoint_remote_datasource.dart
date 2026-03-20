import '../../../../core/network/api_client.dart';
import '../models/endpoint_model.dart';

abstract class EndpointRemoteDataSource {
  Future<List<EndpointModel>> getEndpoints(String projectId);
}

class EndpointRemoteDataSourceImpl implements EndpointRemoteDataSource {
  final ApiClient apiClient;

  EndpointRemoteDataSourceImpl(this.apiClient);

  @override
  Future<List<EndpointModel>> getEndpoints(String projectId) async {
    final response = await apiClient.get('/projects/$projectId/endpoints');
    return (response.data as List)
        .map((json) => EndpointModel.fromJson(json))
        .toList();
  }
}
