import '../../domain/entities/generated_test.dart';

class TestModel extends GeneratedTest {
  const TestModel({
    required super.id,
    required super.projectId,
    required super.framework,
    required super.code,
    required super.totalCases,
    required super.generatedAt,
  });

  factory TestModel.fromJson(Map<String, dynamic> json) {
    return TestModel(
      id: (json['id'] ?? '').toString(),
      projectId: (json['project_id'] ?? '').toString(),
      framework: json['framework'] ?? 'pytest',
      code: json['code'] ?? '',
      totalCases: json['total_cases'] ?? 0,
      generatedAt: DateTime.tryParse(json['generated_at'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'project_id': projectId,
      'framework': framework,
      'code': code,
      'total_cases': totalCases,
      'generated_at': generatedAt.toIso8601String(),
    };
  }
}
