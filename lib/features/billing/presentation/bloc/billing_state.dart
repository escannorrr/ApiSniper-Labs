part of 'billing_bloc.dart';

abstract class BillingState extends Equatable {
  const BillingState();
  
  @override
  List<Object?> get props => [];
}

class BillingInitial extends BillingState {}

class BillingLoading extends BillingState {}

class BillingDataLoaded extends BillingState {
  final List<Plan> plans;
  final Subscription currentSubscription;
  final List<Payment> paymentHistory;

  const BillingDataLoaded({
    required this.plans,
    required this.currentSubscription,
    required this.paymentHistory,
  });

  @override
  List<Object?> get props => [plans, currentSubscription, paymentHistory];
}

class CheckoutReady extends BillingState {
  final Plan selectedPlan;
  final bool isYearly;

  const CheckoutReady({required this.selectedPlan, required this.isYearly});

  @override
  List<Object?> get props => [selectedPlan, isYearly];
}

class PaymentProcessing extends BillingState {}

class PaymentSuccessState extends BillingState {
  final Plan plan;

  const PaymentSuccessState({required this.plan});

  @override
  List<Object?> get props => [plan];
}

class BillingError extends BillingState {
  final String message;

  const BillingError({required this.message});

  @override
  List<Object?> get props => [message];
}
