import 'package:api_sniper_labs/features/endpoints/domain/entities/api_endpoint.dart';

import '../../../../core/errors/exceptions.dart';
import '../../domain/entities/project.dart';
import '../../domain/repositories/project_repository.dart';

class MockProjectRepository implements ProjectRepository {
  final List<Project> _projects = [
    Project(
      id: 'proj_1',
      name: 'Payment Gateway API',
      description: 'Core payment processing and reconciliation hooks.',
      openApiVersion: '3.0.1',
      endpointCount: 24,overallScore: 0,
      createdAt: DateTime.now().subtract(const Duration(days: 4)),
    ),
    Project(
      id: 'proj_2',
      name: 'User Management Service',
      description: 'Directory service containing user profiles and ACL scopes.',
      openApiVersion: '3.1.0',
      endpointCount: 15,
      createdAt: DateTime.now().subtract(const Duration(days: 12)), overallScore: 0,
    ),
    Project(
      id: 'proj_3',
      name: 'Inventory Sync Webhook',
      description: 'Incoming webhooks from fulfillment providers.',
      openApiVersion: '2.0',
      endpointCount: 5,overallScore: 0,
      createdAt: DateTime.now().subtract(const Duration(days: 40)),
    ),
  ];

  @override
  Future<List<Project>> getProjects() async {
    await Future.delayed(const Duration(milliseconds: 800));
    return List.unmodifiable(_projects);
  }

  @override
  Future<Project> getProjectById(String id) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final project = _projects.where((p) => p.id == id).firstOrNull;
    if (project == null) {
      throw ServerException('Project not found');
    }
    return project;
  }

  @override
  Future<Project> createProject(String name, String description) async {
    await Future.delayed(const Duration(milliseconds: 800));
    final newProject = Project(
      id: 'proj_${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      description: description,overallScore: 0,
      openApiVersion: '3.0.0', // default mock
      endpointCount: 0, // Not parsed yet
      createdAt: DateTime.now(),
    );
    _projects.insert(0, newProject);
    return newProject;
  }

  @override
  Future<void> deleteProject(String id) async {
    await Future.delayed(const Duration(milliseconds: 600));
    _projects.removeWhere((p) => p.id == id);
  }

  @override
  Future<List<ApiEndpoint>> getEndpoints(String projectId) {
    // TODO: implement getEndpoints
    throw UnimplementedError();
  }

  @override
  Future<void> uploadSpec(String projectId, file) {
    // TODO: implement uploadSpec
    throw UnimplementedError();
  }
}
