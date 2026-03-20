import 'package:equatable/equatable.dart';

class ApiEndpoint extends Equatable {
  final String id;
  final String projectId;
  final String path;
  final String method;
  final String description;
  final List<ApiParameter> parameters;
  final Map<String, dynamic> requestSchema;
  final Map<String, dynamic> responseSchema;

  const ApiEndpoint({
    required this.id,
    required this.projectId,
    required this.path,
    required this.method,
    required this.description,
    required this.parameters,
    required this.requestSchema,
    required this.responseSchema,
  });

  @override
  List<Object?> get props => [
        id,
        projectId,
        path,
        method,
        description,
        parameters,
        requestSchema,
        responseSchema,
      ];
}

class ApiParameter extends Equatable {
  final String name;
  final String type; // e.g., 'path', 'query', 'header'
  final bool isRequired;

  const ApiParameter({
    required this.name,
    required this.type,
    required this.isRequired,
  });

  @override
  List<Object?> get props => [name, type, isRequired];
}

class ApiResponse extends Equatable {
  final int statusCode;
  final String description;
  final Map<String, dynamic>? schema;

  const ApiResponse({
    required this.statusCode,
    required this.description,
    this.schema,
  });

  @override
  List<Object?> get props => [statusCode, description, schema];
}
