import '../../domain/entities/test_result.dart';

class TestResultModel extends TestResult {
  const TestResultModel({
    required super.totalTests,
    required super.passed,
    required super.failed,
    required super.executionTime,
    super.logs,
  });

  factory TestResultModel.fromJson(Map<String, dynamic> json) {
    return TestResultModel(
      totalTests: json['total_tests'] ?? 0,
      passed: json['passed'] ?? 0,
      failed: json['failed'] ?? 0,
      executionTime: (json['execution_time'] ?? 0.0).toDouble(),
      logs: json['logs'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_tests': totalTests,
      'passed': passed,
      'failed': failed,
      'execution_time': executionTime,
      'logs': logs,
    };
  }
}
