import 'package:equatable/equatable.dart';

class SecurityIssue extends Equatable {
  final String id;
  final String projectId;
  final String endpoint;
  final String issueType;
  final String severity; // High, Medium, Low
  final String description;
  final String recommendation;

  const SecurityIssue({
    required this.id,
    required this.projectId,
    required this.endpoint,
    required this.issueType,
    required this.severity,
    required this.description,
    required this.recommendation,
  });

  @override
  List<Object?> get props => [
        id,
        projectId,
        endpoint,
        issueType,
        severity,
        description,
        recommendation,
      ];
}
