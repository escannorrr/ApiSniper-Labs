import '../../domain/entities/generated_test.dart';
import '../../domain/entities/test_result.dart';
import '../../domain/repositories/test_repository.dart';
import '../datasources/test_remote_datasource.dart';

class TestRepositoryImpl implements TestRepository {
  final TestRemoteDataSource remoteDataSource;

  TestRepositoryImpl({required this.remoteDataSource});

  @override
  Future<GeneratedTest> generateTests(String projectId, String language) async {
    return await remoteDataSource.generateTests(projectId, language);
  }

  @override
  Future<TestResult> runTests(String projectId) async {
    return await remoteDataSource.runTests(projectId);
  }
}
