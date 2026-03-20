import 'dart:io';
import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../models/project_model.dart';
import '../../../../features/endpoints/data/models/endpoint_model.dart';

abstract class ProjectRemoteDataSource {
  Future<List<ProjectModel>> getProjects();
  Future<ProjectModel> getProjectById(String id);
  Future<ProjectModel> createProject(String name, String description);
  Future<void> deleteProject(String id);
  Future<void> uploadSpec(String projectId, dynamic file);
  Future<List<EndpointModel>> getEndpoints(String projectId);
}

class ProjectRemoteDataSourceImpl implements ProjectRemoteDataSource {
  final ApiClient apiClient;

  ProjectRemoteDataSourceImpl(this.apiClient);

  @override
  Future<List<ProjectModel>> getProjects() async {
    final response = await apiClient.get('/projects');
    return (response.data as List)
        .map((json) => ProjectModel.fromJson(json))
        .toList();
  }

  @override
  Future<ProjectModel> getProjectById(String id) async {
    final response = await apiClient.get('/projects/$id');
    return ProjectModel.fromJson(response.data);
  }

  @override
  Future<ProjectModel> createProject(String name, String description) async {
    final response = await apiClient.post('/projects', data: {
      'name': name,
      'description': description,
    });
    return ProjectModel.fromJson(response.data);
  }

  @override
  Future<void> deleteProject(String id) async {
    await apiClient.delete('/projects/$id');
  }

  @override
  Future<void> uploadSpec(String projectId, dynamic file) async {
    // Handle file upload (Multipart)
    // 'file' could be File or Uint8List depending on platform (web vs mobile)
    // For Flutter Web, we usually use MultipartFile.fromBytes
    
    FormData formData = FormData.fromMap({
      'file': file, // Expecting MultipartFile here from repository
    });

    await apiClient.post('/projects/$projectId/upload-spec', data: formData);
  }

  @override
  Future<List<EndpointModel>> getEndpoints(String projectId) async {
    final response = await apiClient.get('/projects/$projectId/endpoints');
    return (response.data as List)
        .map((json) => EndpointModel.fromJson(json))
        .toList();
  }
}
