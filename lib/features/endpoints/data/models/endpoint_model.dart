import '../../domain/entities/api_endpoint.dart';

class EndpointModel extends ApiEndpoint {
  const EndpointModel({
    required super.id,
    required super.projectId,
    required super.path,
    required super.method,
    required super.description,
    required super.parameters,
    required super.requestSchema,
    required super.responseSchema,
  });

  factory EndpointModel.fromJson(Map<String, dynamic> json) {
    return EndpointModel(
      id: (json['id'] ?? '').toString(),
      projectId: (json['project_id'] ?? '').toString(),
      path: json['path'] ?? '',
      method: json['method'] ?? '',
      description: json['description'] ?? '',
      parameters: (json['parameters'] as List? ?? [])
          .map((p) => ApiParameterModel.fromJson(p))
          .toList(),
      requestSchema: json['request_schema'] ?? {},
      responseSchema: json['response_schema'] ?? {},
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'project_id': projectId,
      'path': path,
      'method': method,
      'description': description,
      'parameters': parameters.map((p) => (p as ApiParameterModel).toJson()).toList(),
      'request_schema': requestSchema,
      'response_schema': responseSchema,
    };
  }
}

class ApiParameterModel extends ApiParameter {
  const ApiParameterModel({
    required super.name,
    required super.type,
    required super.isRequired,
  });

  factory ApiParameterModel.fromJson(Map<String, dynamic> json) {
    return ApiParameterModel(
      name: json['name'] ?? '',
      type: json['type'] ?? 'query',
      isRequired: json['required'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'type': type,
      'required': isRequired,
    };
  }
}
