import '../entities/project.dart';
import '../../../../features/endpoints/domain/entities/api_endpoint.dart';

abstract class ProjectRepository {
  Future<List<Project>> getProjects();
  Future<Project> getProjectById(String id);
  Future<Project> createProject(String name, String description);
  Future<void> deleteProject(String id);
  Future<void> uploadSpec(String projectId, dynamic file);
  Future<List<ApiEndpoint>> getEndpoints(String projectId);
}
