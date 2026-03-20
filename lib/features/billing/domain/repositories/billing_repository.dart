import '../entities/plan.dart';
import '../entities/subscription.dart';
import '../entities/payment.dart';

abstract class BillingRepository {
  Future<List<Plan>> getPlans();
  Future<Subscription> getCurrentSubscription();
  Future<void> checkoutPlan(String planId, bool isYearly);
  Future<void> cancelSubscription();
  Future<List<Payment>> getPaymentHistory();
}
