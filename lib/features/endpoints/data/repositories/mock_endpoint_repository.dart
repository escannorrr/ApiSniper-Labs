import '../../domain/entities/api_endpoint.dart';
import '../../domain/repositories/endpoint_repository.dart';

class MockEndpointRepository implements EndpointRepository {
  final List<ApiEndpoint> _demoEndpoints = const [
    ApiEndpoint(
      id: 'ep_1',
      projectId: 'proj_1', // Payment Gateway
      path: '/v1/payments/process',
      method: 'POST',
      description: 'Processes a new credit card charge securely.',
      parameters: [],
      requestSchema: {
         "type": "object",
         "properties": {
            "amount": {"type": "integer"},
            "currency": {"type": "string"},
            "source": {"type": "string"},
            "description": {"type": "string"}
         },
         "required": ["amount", "currency", "source"]
      },
      responseSchema: {
        "type": "object",
        "properties": {
          "id": {"type": "string"},
          "status": {"type": "string", "enum": ["succeeded", "failed"]},
          "amount_captured": {"type": "integer"}
        }
      },
    ),
    ApiEndpoint(
      id: 'ep_2',
      projectId: 'proj_1',
      path: '/v1/payments/{id}',
      method: 'GET',
      description: 'Retrieve details of a specific payment.',
      parameters: [
        ApiParameter(name: 'id', type: 'path', isRequired: true)
      ],
      requestSchema: {},
      responseSchema: {
        "type": "object",
        "properties": {
          "id": {"type": "string"},
          "status": {"type": "string"},
          "amount": {"type": "integer"},
          "created_at": {"type": "string", "format": "date-time"}
        }
      },
    ),
    ApiEndpoint(
      id: 'ep_3',
      projectId: 'proj_1',
      path: '/v1/refunds',
      method: 'POST',
      description: 'Issue a refund for a previously captured payment.',
      parameters: [],
      requestSchema: {
        "type": "object",
        "properties": {
          "payment_id": {"type": "string"},
          "amount": {"type": "integer"},
          "reason": {"type": "string"}
        },
        "required": ["payment_id"]
      },
      responseSchema: {
        "type": "object",
        "properties": {
          "id": {"type": "string"},
          "status": {"type": "string"},
          "payment_id": {"type": "string"}
        }
      },
    ),
  ];

  @override
  Future<List<ApiEndpoint>> getEndpoints(String projectId) async {
    await Future.delayed(const Duration(milliseconds: 600));
    // For the UI mockup, we will return the demo endpoints regardless of project ID 
    // to ensure there's always data on screen.
    return List.unmodifiable(_demoEndpoints);
  }
}
