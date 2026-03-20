import '../../domain/entities/plan.dart';
import '../../domain/entities/subscription.dart';
import '../../domain/entities/payment.dart';

class PlanModel extends Plan {
  const PlanModel({
    required super.id,
    required super.name,
    required super.monthlyPrice,
    required super.yearlyPrice,
    required super.maxProjects,
    required super.maxTestGenerations,
    required super.prioritySupport,
  });

  factory PlanModel.fromJson(Map<String, dynamic> json) {
    final name = json['name'] ?? '';
    // If id is missing, use name as id to match our fallback subscription
    final id = (json['id'] ?? name).toString();
    
    // Sensible defaults based on plan name if limits are missing
    int maxProjects = json['max_projects'] ?? 0;
    int maxTests = json['max_test_generations'] ?? 0;
    
    if (maxProjects == 0) {
      if (name == 'Free') maxProjects = 1;
      else if (name == 'Pro') maxProjects = 10;
      else if (name == 'Team') maxProjects = 10000; // Unlimited
    }
    
    if (maxTests == 0) {
      if (name == 'Free') maxTests = 10;
      else if (name == 'Pro') maxTests = 10000;
      else if (name == 'Team') maxTests = 10000;
    }

    return PlanModel(
      id: id,
      name: name,
      monthlyPrice: json['monthly_price'] ?? json['price'] ?? 0,
      yearlyPrice: json['yearly_price'] ?? 0,
      maxProjects: maxProjects,
      maxTestGenerations: maxTests,
      prioritySupport: json['priority_support'] ?? false,
    );
  }
}

class SubscriptionModel extends Subscription {
  const SubscriptionModel({
    required super.id,
    required super.userId,
    required super.planId,
    required super.startDate,
    required super.nextBillingDate,
    required super.status,
  });

  factory SubscriptionModel.fromJson(Map<String, dynamic> json) {
    return SubscriptionModel(
      id: (json['id'] ?? '').toString(),
      userId: (json['user_id'] ?? '').toString(),
      planId: (json['plan_id'] ?? '').toString(),
      startDate: DateTime.tryParse(json['start_date'] ?? '') ?? DateTime.now(),
      nextBillingDate: DateTime.tryParse(json['next_billing_date'] ?? '') ?? DateTime.now(),
      status: _parseStatus(json['status']),
    );
  }

  static SubscriptionStatus _parseStatus(String? status) {
    switch (status) {
      case 'active':
        return SubscriptionStatus.active;
      case 'cancelled':
        return SubscriptionStatus.cancelled;
      case 'expired':
        return SubscriptionStatus.expired;
      default:
        return SubscriptionStatus.active;
    }
  }
}

class PaymentModel extends Payment {
  const PaymentModel({
    required super.id,
    required super.planId,
    required super.amount,
    required super.paymentDate,
    required super.paymentStatus,
  });

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
      id: (json['id'] ?? '').toString(),
      planId: (json['plan_id'] ?? '').toString(),
      amount: json['amount'] ?? 0,
      paymentDate: DateTime.tryParse(json['payment_date'] ?? '') ?? DateTime.now(),
      paymentStatus: _parseStatus(json['status']),
    );
  }

  static PaymentStatus _parseStatus(String? status) {
    switch (status) {
      case 'successful':
        return PaymentStatus.successful;
      case 'pending':
        return PaymentStatus.pending;
      case 'failed':
        return PaymentStatus.failed;
      default:
        return PaymentStatus.successful;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'plan_id': planId,
      'amount': amount,
      'payment_date': paymentDate.toIso8601String(),
      'status': paymentStatus.name,
    };
  }
}
