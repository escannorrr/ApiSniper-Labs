import '../../domain/entities/security_issue.dart';

class SecurityModel extends SecurityIssue {
  const SecurityModel({
    required super.id,
    required super.projectId,
    required super.endpoint,
    required super.issueType,
    required super.severity,
    required super.description,
    required super.recommendation,
  });

  factory SecurityModel.fromJson(Map<String, dynamic> json) {
    return SecurityModel(
      id: (json['id'] ?? '').toString(),
      projectId: (json['project_id'] ?? '').toString(),
      endpoint: json['endpoint'] ?? '',
      issueType: json['issue_type'] ?? '',
      severity: json['severity'] ?? 'Low',
      description: json['description'] ?? '',
      recommendation: json['recommendation'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'project_id': projectId,
      'endpoint': endpoint,
      'issue_type': issueType,
      'severity': severity,
      'description': description,
      'recommendation': recommendation,
    };
  }
}
