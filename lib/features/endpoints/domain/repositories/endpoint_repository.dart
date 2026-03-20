import '../entities/api_endpoint.dart';

abstract class EndpointRepository {
  Future<List<ApiEndpoint>> getEndpoints(String projectId);
}
