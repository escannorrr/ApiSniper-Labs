import 'package:api_sniper_labs/features/test_generation/domain/entities/test_result.dart';

import '../../domain/entities/generated_test.dart';
import '../../domain/repositories/test_repository.dart';

class MockTestRepository implements TestRepository {
  @override
  Future<GeneratedTest> generateTests(String projectId, String framework) async {
    // Simulate network delay for AI test generation
    await Future.delayed(const Duration(seconds: 3));

    return GeneratedTest(
      id: 'test_${DateTime.now().millisecondsSinceEpoch}',
      projectId: projectId,
      framework: framework,
      totalCases: 25,
      generatedAt: DateTime.now(),
      code: '''
import pytest
import requests

BASE_URL = "https://api.mockapisniper.local/v1"

def test_payments_process_success():
    """Charge a valid payment details should succeed."""
    payload = {
        "amount": 2000,
        "currency": "usd",
        "source": "src_tok_123",
        "description": "Premium Plan"
    }
    response = requests.post(f"{BASE_URL}/payments/process", json=payload)
    
    assert response.status_code == 200
    data = response.json()
    assert data["status"] == "succeeded"
    assert data["amount_captured"] == 2000

def test_payments_process_missing_amount():
    """Missing amount should result in validation error."""
    payload = {
        "currency": "usd",
        "source": "src_tok_123"
    }
    response = requests.post(f"{BASE_URL}/payments/process", json=payload)
    
    assert response.status_code == 400
    assert "amount" in response.json()["error"]["details"]
''',
    );
  }

  @override
  Future<TestResult> runTests(String projectId) {
    // TODO: implement runTests
    throw UnimplementedError();
  }
}
