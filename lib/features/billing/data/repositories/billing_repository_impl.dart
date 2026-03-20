import '../../domain/entities/plan.dart';
import '../../domain/entities/subscription.dart';
import '../../domain/entities/payment.dart';
import '../../domain/repositories/billing_repository.dart';
import '../datasources/billing_remote_datasource.dart';

class BillingRepositoryImpl implements BillingRepository {
  final BillingRemoteDataSource remoteDataSource;

  BillingRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Plan>> getPlans() async {
    final models = await remoteDataSource.getPlans();
    return models.cast<Plan>().toList();
  }

  @override
  Future<Subscription> getCurrentSubscription() async {
    return await remoteDataSource.getCurrentSubscription();
  }

  @override
  Future<void> checkoutPlan(String planId, bool isYearly) async {
    return await remoteDataSource.checkoutPlan(planId, isYearly);
  }

  @override
  Future<void> cancelSubscription() async {
    return await remoteDataSource.cancelSubscription();
  }

  @override
  Future<List<Payment>> getPaymentHistory() async {
    final models = await remoteDataSource.getPaymentHistory();
    return models.cast<Payment>().toList();
  }
}
