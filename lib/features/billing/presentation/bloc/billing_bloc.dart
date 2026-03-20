import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/plan.dart';
import '../../domain/entities/subscription.dart';
import '../../domain/entities/payment.dart';
import '../../domain/repositories/billing_repository.dart';

part 'billing_event.dart';
part 'billing_state.dart';

class BillingBloc extends Bloc<BillingEvent, BillingState> {
  final BillingRepository repository;

  BillingBloc({required this.repository}) : super(BillingInitial()) {
    on<LoadBillingDataRequested>(_onLoadBillingData);
    on<StartCheckoutRequested>(_onStartCheckout);
    on<ProcessPaymentRequested>(_onProcessPayment);
    on<CancelSubscriptionRequested>(_onCancelSubscription);
  }

  Future<void> _onLoadBillingData(LoadBillingDataRequested event, Emitter<BillingState> emit) async {
    emit(BillingLoading());
    try {
      final plans = await repository.getPlans();
      final currentSub = await repository.getCurrentSubscription();
      final history = await repository.getPaymentHistory();

      emit(BillingDataLoaded(
        plans: plans,
        currentSubscription: currentSub,
        paymentHistory: history,
      ));
    } catch (e) {
      emit(BillingError(message: e.toString()));
    }
  }

  Future<void> _onStartCheckout(StartCheckoutRequested event, Emitter<BillingState> emit) async {
     try {
       final plans = await repository.getPlans();
       final selectedPlan = plans.firstWhere((p) => p.id == event.planId);
       emit(CheckoutReady(selectedPlan: selectedPlan, isYearly: event.isYearly));
     } catch(e) {
       emit(BillingError(message: e.toString()));
     }
  }

  Future<void> _onProcessPayment(ProcessPaymentRequested event, Emitter<BillingState> emit) async {
    emit(PaymentProcessing());
    try {
      await repository.checkoutPlan(event.planId, event.isYearly);
      final plans = await repository.getPlans();
      final selectedPlan = plans.firstWhere((p) => p.id == event.planId);
      emit(PaymentSuccessState(plan: selectedPlan));
    } catch (e) {
       emit(BillingError(message: e.toString()));
       // If fail, reload current data state
       add(LoadBillingDataRequested());
    }
  }

  Future<void> _onCancelSubscription(CancelSubscriptionRequested event, Emitter<BillingState> emit) async {
     emit(BillingLoading());
     try {
       await repository.cancelSubscription();
       add(LoadBillingDataRequested());
     } catch (e) {
       emit(BillingError(message: e.toString()));
       add(LoadBillingDataRequested());
     }
  }
}
