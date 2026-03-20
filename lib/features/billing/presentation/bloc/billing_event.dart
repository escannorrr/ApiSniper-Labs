part of 'billing_bloc.dart';

abstract class BillingEvent extends Equatable {
  const BillingEvent();

  @override
  List<Object?> get props => [];
}

class LoadBillingDataRequested extends BillingEvent {}

class SelectPlanRequested extends BillingEvent {
  final String planId;

  const SelectPlanRequested({required this.planId});

  @override
  List<Object?> get props => [planId];
}

class StartCheckoutRequested extends BillingEvent {
  final String planId;
  final bool isYearly;

  const StartCheckoutRequested({required this.planId, required this.isYearly});

  @override
  List<Object?> get props => [planId, isYearly];
}

class ProcessPaymentRequested extends BillingEvent {
  final String planId;
  final bool isYearly;

  const ProcessPaymentRequested({required this.planId, required this.isYearly});

  @override
  List<Object?> get props => [planId, isYearly];
}

class CancelSubscriptionRequested extends BillingEvent {}
