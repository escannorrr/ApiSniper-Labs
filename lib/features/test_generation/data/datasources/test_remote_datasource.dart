import '../../../../core/network/api_client.dart';
import '../models/test_model.dart';
import '../models/test_result_model.dart';

abstract class TestRemoteDataSource {
  Future<TestModel> generateTests(String projectId, String framework);
  Future<TestResultModel> runTests(String projectId);
}

class TestRemoteDataSourceImpl implements TestRemoteDataSource {
  final ApiClient apiClient;

  TestRemoteDataSourceImpl(this.apiClient);

  @override
  Future<TestModel> generateTests(String projectId, String language) async {
    final response = await apiClient.post('/projects/$projectId/generate-tests', data: {
      'language': language,
    });
    return TestModel.fromJson(response.data);
  }

  @override
  Future<TestResultModel> runTests(String projectId) async {
    final response = await apiClient.post('/projects/$projectId/run-tests');
    return TestResultModel.fromJson(response.data);
  }
}
