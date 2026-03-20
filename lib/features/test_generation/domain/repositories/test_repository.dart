import '../entities/generated_test.dart';
import '../entities/test_result.dart';

abstract class TestRepository {
  Future<GeneratedTest> generateTests(String projectId, String language);
  Future<TestResult> runTests(String projectId);
}
