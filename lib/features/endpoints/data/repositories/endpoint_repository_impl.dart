import '../../domain/entities/api_endpoint.dart';
import '../../domain/repositories/endpoint_repository.dart';
import '../datasources/endpoint_remote_datasource.dart';

class EndpointRepositoryImpl implements EndpointRepository {
  final EndpointRemoteDataSource remoteDataSource;

  EndpointRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<ApiEndpoint>> getEndpoints(String projectId) async {
    return await remoteDataSource.getEndpoints(projectId);
  }
}
