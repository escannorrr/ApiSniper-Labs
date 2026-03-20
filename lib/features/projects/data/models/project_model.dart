import '../../domain/entities/project.dart';

class ProjectModel extends Project {
  const ProjectModel({
    required super.id,
    required super.name,
    required super.description,
    required super.openApiVersion,
    required super.endpointCount,
    required super.overallScore,
    required super.createdAt,
  });

  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    return ProjectModel(
      id: (json['id'] ?? json['project_id'] ?? '').toString(),
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      openApiVersion: json['openapi_version'] ?? '3.0.0',
      endpointCount: json['endpoint_count'] ?? 0,
      overallScore: json['overall_score'] ?? 0,
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'openapi_version': openApiVersion,
      'endpoint_count': endpointCount,
      'overall_score': overallScore,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
