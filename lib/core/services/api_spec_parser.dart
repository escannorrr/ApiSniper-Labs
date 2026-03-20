import 'dart:convert';
import '../../features/endpoints/domain/entities/api_endpoint.dart';

enum SpecFormat { openapi, swagger, postman, unknown }

class ApiSpecParser {
  /// Parses standard OpenAPI/Swagger/Postman JSON and extracts a generic list of endpoints.
  static Future<List<ApiEndpoint>> parseJson(String jsonContent, String projectId) async {
    try {
      final Map<String, dynamic> data = jsonDecode(jsonContent);
      final format = _detectFormat(data);

      switch (format) {
        case SpecFormat.openapi:
        case SpecFormat.swagger:
          return _parseOpenApiOrSwagger(data, projectId);
        case SpecFormat.postman:
          return _parsePostman(data, projectId);
        default:
          throw const FormatException('Unsupported API specification format');
      }
    } catch (e) {
      throw FormatException('Failed to parse API specification: $e');
    }
  }

  static SpecFormat _detectFormat(Map<String, dynamic> data) {
    if (data.containsKey('openapi')) return SpecFormat.openapi;
    if (data.containsKey('swagger')) return SpecFormat.swagger;
    if (data.containsKey('info') && data['info'] is Map && data['info']['schema'] != null) {
      final schemaUrl = data['info']['schema'].toString().toLowerCase();
      if (schemaUrl.contains('postman')) return SpecFormat.postman;
    }
    return SpecFormat.unknown;
  }

  static List<ApiEndpoint> _parseOpenApiOrSwagger(Map<String, dynamic> data, String projectId) {
    final List<ApiEndpoint> endpoints = [];
    final Map<String, dynamic>? paths = data['paths'] as Map<String, dynamic>?;

    if (paths == null) return endpoints;

    paths.forEach((pathUrl, pathItem) {
      if (pathItem is! Map<String, dynamic>) return;

      pathItem.forEach((method, operation) {
        if (!['get', 'post', 'put', 'delete', 'patch'].contains(method.toLowerCase())) return;
        if (operation is! Map<String, dynamic>) return;

        endpoints.add(ApiEndpoint(
          id: DateTime.now().millisecondsSinceEpoch.toString() + endpoints.length.toString(),
          projectId: projectId,
          path: pathUrl,
          method: method.toUpperCase(),
          description: operation['summary'] ?? operation['description'] ?? 'No description',
          parameters: _extractOpenApiParameters(operation['parameters'] as List?),
          requestSchema: _extractOpenApiRequestBody(operation['requestBody']),
          responseSchema: _extractOpenApiResponse(operation['responses']),
        ));
      });
    });

    return endpoints;
  }

  static List<ApiEndpoint> _parsePostman(Map<String, dynamic> data, String projectId) {
    final List<ApiEndpoint> endpoints = [];
    final List<dynamic>? item = data['item'] as List<dynamic>?;

    if (item == null) return endpoints;

    void processItems(List<dynamic> items, String currentPath) {
      for (final it in items) {
        if (it is! Map<String, dynamic>) continue;

        if (it.containsKey('item')) { // It's a folder
          processItems(it['item'] as List<dynamic>, currentPath);
        } else if (it.containsKey('request')) { // It's an endpoint
          final request = it['request'];
          if (request is! Map<String, dynamic>) continue;

          String path = '';
          if (request['url'] is Map && request['url']['raw'] != null) {
             path = request['url']['raw'];
          } else if (request['url'] is String) {
             path = request['url'];
          }

          endpoints.add(ApiEndpoint(
            id: DateTime.now().millisecondsSinceEpoch.toString() + endpoints.length.toString(),
            projectId: projectId,
            path: path,
            method: (request['method'] ?? 'GET').toString().toUpperCase(),
            description: it['name'] ?? 'No description',
            parameters: [], // Postman parameters parsing could be complex for this scope
            requestSchema: {}, // Simplified
            responseSchema: {}, // Simplified
          ));
        }
      }
    }

    processItems(item, '');
    return endpoints;
  }

  static List<ApiParameter> _extractOpenApiParameters(List<dynamic>? paramsRef) {
    final List<ApiParameter> params = [];
    if (paramsRef == null) return params;

    for (final param in paramsRef) {
      if (param is Map<String, dynamic>) {
        params.add(ApiParameter(
          name: param['name'] ?? 'Unknown',
          type: param['in'] ?? 'query',
          isRequired: param['required'] == true,
        ));
      }
    }
    return params;
  }

  static Map<String, dynamic> _extractOpenApiRequestBody(dynamic requestBody) {
    if (requestBody is Map<String, dynamic> && requestBody.containsKey('content')) {
      final content = requestBody['content'];
      if (content is Map<String, dynamic> && content.containsKey('application/json')) {
         final appJson = content['application/json'];
         if (appJson is Map<String,dynamic> && appJson.containsKey('schema')){
             return appJson['schema'] as Map<String,dynamic>;
         }
      }
    }
    return {};
  }
  
  static Map<String, dynamic> _extractOpenApiResponse(dynamic responses) {
    if (responses is Map<String, dynamic>) {
        return responses; // Simplified representation returning the entire mapping
    }
    return {};
  }
}
