import '../entities/security_issue.dart';

abstract class SecurityRepository {
  Future<List<SecurityIssue>> getSecurityIssues(String projectId);
}
