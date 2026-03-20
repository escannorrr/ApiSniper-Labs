import 'package:equatable/equatable.dart';

class TestResult extends Equatable {
  final int totalTests;
  final int passed;
  final int failed;
  final double executionTime;
  final String? logs;

  const TestResult({
    required this.totalTests,
    required this.passed,
    required this.failed,
    required this.executionTime,
    this.logs,
  });

  @override
  List<Object?> get props => [totalTests, passed, failed, executionTime, logs];
}
