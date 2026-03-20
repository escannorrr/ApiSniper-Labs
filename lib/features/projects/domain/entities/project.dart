import 'package:equatable/equatable.dart';

class Project extends Equatable {
  final String id;
  final String name;
  final String description;
  final String openApiVersion;
  final int endpointCount;
  final int overallScore;
  final DateTime createdAt;

  const Project({
    required this.id,
    required this.name,
    required this.description,
    required this.openApiVersion,
    required this.endpointCount,
    required this.overallScore,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        openApiVersion,
        endpointCount,
        overallScore,
        createdAt,
      ];
}
