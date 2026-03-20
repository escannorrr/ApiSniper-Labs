import '../../domain/entities/project.dart';
import '../../domain/repositories/project_repository.dart';
import '../../../../features/endpoints/domain/entities/api_endpoint.dart';
import '../datasources/project_remote_datasource.dart';

class ProjectRepositoryImpl implements ProjectRepository {
  final ProjectRemoteDataSource remoteDataSource;

  ProjectRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Project>> getProjects() async {
    return await remoteDataSource.getProjects();
  }

  @override
  Future<Project> getProjectById(String id) async {
    return await remoteDataSource.getProjectById(id);
  }

  @override
  Future<Project> createProject(String name, String description) async {
    return await remoteDataSource.createProject(name, description);
  }

  @override
  Future<void> deleteProject(String id) async {
    return await remoteDataSource.deleteProject(id);
  }

  @override
  Future<void> uploadSpec(String projectId, dynamic file) async {
    return await remoteDataSource.uploadSpec(projectId, file);
  }

  @override
  Future<List<ApiEndpoint>> getEndpoints(String projectId) async {
    final models = await remoteDataSource.getEndpoints(projectId);
    return models; // EndpointModel extends ApiEndpoint
  }
  
  // Note: The original interface for ProjectRepository didn't have uploadSpec.
  // I should check domain/repositories/project_repository.dart
}
