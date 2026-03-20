import '../../domain/entities/plan.dart';
import '../../domain/entities/subscription.dart';
import '../../domain/entities/payment.dart';
import '../../domain/repositories/billing_repository.dart';

class MockBillingRepository implements BillingRepository {
  final List<Plan> _plans = const [
    Plan(
      id: 'plan_free',
      name: 'Free',
      monthlyPrice: 0,
      yearlyPrice: 0,
      maxProjects: 1,
      maxTestGenerations: 20,
      prioritySupport: false,
    ),
    Plan(
      id: 'plan_pro',
      name: 'Pro',
      monthlyPrice: 499,
      yearlyPrice: 4990,
      maxProjects: 10,
      maxTestGenerations: 500,
      prioritySupport: false,
    ),
    Plan(
      id: 'plan_team',
      name: 'Team',
      monthlyPrice: 1999,
      yearlyPrice: 19990,
      maxProjects: 9999, // Represents Unlimited
      maxTestGenerations: 99999, // Represents Unlimited
      prioritySupport: true,
    ),
  ];

  Subscription _currentSubscription = Subscription(
    id: 'sub_12345',
    userId: 'user_1',
    planId: 'plan_free',
    startDate: DateTime.now().subtract(const Duration(days: 30)),
    nextBillingDate: DateTime.now().add(const Duration(days: 365)),
    status: SubscriptionStatus.active,
  );

  final List<Payment> _paymentHistory = [
    Payment(
      id: 'pay_1',
      planId: 'plan_free',
      amount: 0,
      paymentDate: DateTime.now().subtract(const Duration(days: 30)),
      paymentStatus: PaymentStatus.successful,
    )
  ];

  @override
  Future<List<Plan>> getPlans() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return List.unmodifiable(_plans);
  }

  @override
  Future<Subscription> getCurrentSubscription() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return _currentSubscription;
  }

  @override
  Future<void> checkoutPlan(String planId, bool isYearly) async {
    await Future.delayed(const Duration(seconds: 2)); // Simulate payment processing
    
    final plan = _plans.firstWhere((p) => p.id == planId);
    final amount = isYearly ? plan.yearlyPrice : plan.monthlyPrice;

    // Update Subscription
    _currentSubscription = Subscription(
      id: 'sub_${DateTime.now().millisecondsSinceEpoch}',
      userId: 'user_1',
      planId: planId,
      startDate: DateTime.now(),
      nextBillingDate: isYearly 
          ? DateTime.now().add(const Duration(days: 365)) 
          : DateTime.now().add(const Duration(days: 30)),
      status: SubscriptionStatus.active,
    );

    // Add Payment Record
    _paymentHistory.insert(0, Payment(
      id: 'pay_${DateTime.now().millisecondsSinceEpoch}',
      planId: planId,
      amount: amount,
      paymentDate: DateTime.now(),
      paymentStatus: PaymentStatus.successful,
    ));
  }

  @override
  Future<void> cancelSubscription() async {
    await Future.delayed(const Duration(milliseconds: 800));
    _currentSubscription = Subscription(
      id: _currentSubscription.id,
      userId: _currentSubscription.userId,
      planId: _currentSubscription.planId,
      startDate: _currentSubscription.startDate,
      nextBillingDate: _currentSubscription.nextBillingDate,
      status: SubscriptionStatus.cancelled,
    );
  }

  @override
  Future<List<Payment>> getPaymentHistory() async {
    await Future.delayed(const Duration(milliseconds: 600));
    return List.unmodifiable(_paymentHistory);
  }
}
