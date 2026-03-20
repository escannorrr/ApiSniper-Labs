import '../../../../core/network/api_client.dart';
import '../models/billing_models.dart';
import '../../domain/entities/subscription.dart';

abstract class BillingRemoteDataSource {
  Future<List<PlanModel>> getPlans();
  Future<SubscriptionModel> getCurrentSubscription();
  Future<void> checkoutPlan(String planId, bool isYearly);
  Future<void> cancelSubscription();
  Future<List<PaymentModel>> getPaymentHistory();
}

class BillingRemoteDataSourceImpl implements BillingRemoteDataSource {
  final ApiClient apiClient;

  BillingRemoteDataSourceImpl(this.apiClient);

  @override
  Future<List<PlanModel>> getPlans() async {
    final response = await apiClient.get('/billing/plans');
    return (response.data as List)
        .map((json) => PlanModel.fromJson(json))
        .toList();
  }

  @override
  Future<SubscriptionModel> getCurrentSubscription() async {
    try {
      final response = await apiClient.get('/billing/subscription');
      return SubscriptionModel.fromJson(response.data);
    } catch (e) {
      if (e.toString().contains('404')) {
        // Return a default "Free" subscription if none exists
        return SubscriptionModel(
          id: '0',
          userId: '0',
          planId: 'Free',
          startDate: DateTime.now(),
          nextBillingDate: DateTime.now().add(const Duration(days: 30)),
          status: SubscriptionStatus.active,
        );
      }
      rethrow;
    }
  }

  @override
  Future<void> checkoutPlan(String planId, bool isYearly) async {
    await apiClient.post('/billing/subscribe', data: {
      'plan_id': planId,
      'is_yearly': isYearly,
    });
  }

  @override
  Future<void> cancelSubscription() async {
    await apiClient.post('/billing/cancel');
  }

  @override
  Future<List<PaymentModel>> getPaymentHistory() async {
    try {
      final response = await apiClient.get('/billing/payments');
      return (response.data as List)
          .map((json) => PaymentModel.fromJson(json))
          .toList();
    } catch (e) {
      if (e.toString().contains('404')) {
        return [];
      }
      rethrow;
    }
  }
}
