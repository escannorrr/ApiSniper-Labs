import '../../domain/entities/security_issue.dart';
import '../../domain/repositories/security_repository.dart';

class MockSecurityRepository implements SecurityRepository {
  final List<SecurityIssue> _demoIssues = const [
    SecurityIssue(
      id: 'sec_1',
      projectId: 'proj_1',
      endpoint: 'POST /v1/payments/process',
      issueType: 'Missing Input Validation',
      severity: 'High',
      description: 'The amount field does not explicitly reject negative values in the schema definition, potentially allowing reverse charges.',
      recommendation: 'Update OpenAPI schema to include "minimum": 1 for the amount parameter.',
    ),
    SecurityIssue(
      id: 'sec_2',
      projectId: 'proj_1',
      endpoint: 'POST /v1/payments/process',
      issueType: 'Missing Rate Limiting Headers',
      severity: 'Medium',
      description: 'Endpoint lacks standard rate limiting header definitions (X-RateLimit-Limit, etc).',
      recommendation: 'Include standard rate limiting headers in the 429 and 200 response definitions.',
    ),
    SecurityIssue(
      id: 'sec_3',
      projectId: 'proj_1',
      endpoint: 'GET /v1/payments/{id}',
      issueType: 'Data Exposure',
      severity: 'Low',
      description: 'Response definition includes full user objects rather than referenced IDs, which may leak PII unnecessarily.',
      recommendation: 'Trim response schema to return only essential data or use a reference UUID.',
    ),
  ];

  @override
  Future<List<SecurityIssue>> getSecurityIssues(String projectId) async {
    await Future.delayed(const Duration(milliseconds: 1200));
    return List.unmodifiable(_demoIssues);
  }
}
