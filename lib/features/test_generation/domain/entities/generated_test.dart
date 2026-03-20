import 'package:equatable/equatable.dart';

class GeneratedTest extends Equatable {
  final String id;
  final String projectId;
  final String framework; // e.g., 'pytest', 'jest'
  final String code;
  final int totalCases;
  final DateTime generatedAt;

  const GeneratedTest({
    required this.id,
    required this.projectId,
    required this.framework,
    required this.code,
    required this.totalCases,
    required this.generatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        projectId,
        framework,
        code,
        totalCases,
        generatedAt,
      ];
}
