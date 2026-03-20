import 'package:equatable/equatable.dart';

class ProjectSummary extends Equatable {
  final String id;
  final String name;
  final int endpointsCount;
  final int overallScore;
  final DateTime lastAnalyzed;
  final int securityIssues;

  const ProjectSummary({
    required this.id,
    required this.name,
    required this.endpointsCount,
    required this.overallScore,
    required this.lastAnalyzed,
    required this.securityIssues,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        endpointsCount,
        overallScore,
        lastAnalyzed,
        securityIssues,
      ];
}
