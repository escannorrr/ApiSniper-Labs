import 'package:equatable/equatable.dart';

enum SubscriptionStatus { active, cancelled, expired }

class Subscription extends Equatable {
  final String id;
  final String userId;
  final String planId;
  final DateTime startDate;
  final DateTime nextBillingDate;
  final SubscriptionStatus status;

  const Subscription({
    required this.id,
    required this.userId,
    required this.planId,
    required this.startDate,
    required this.nextBillingDate,
    required this.status,
  });

  @override
  List<Object?> get props => [
        id,
        userId,
        planId,
        startDate,
        nextBillingDate,
        status,
      ];
}
