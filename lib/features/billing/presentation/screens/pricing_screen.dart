import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/widgets/app_loader.dart';
import '../../../../core/widgets/app_error.dart';
import '../bloc/billing_bloc.dart';
import '../../domain/entities/plan.dart';

class PricingScreen extends StatefulWidget {
  const PricingScreen({super.key});

  @override
  State<PricingScreen> createState() => _PricingScreenState();
}

class _PricingScreenState extends State<PricingScreen> {
  bool _isYearly = false;

  @override
  void initState() {
    super.initState();
    context.read<BillingBloc>().add(LoadBillingDataRequested());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BillingBloc, BillingState>(
      listener: (context, state) {
         if (state is CheckoutReady) {
           context.push('/checkout');
         }
      },
      builder: (context, state) {
        if (state is BillingLoading || state is BillingInitial) {
          return const AppLoader(message: 'Loading plans...');
        } else if (state is BillingError) {
          return AppError(
            message: state.message,
            onRetry: () => context.read<BillingBloc>().add(LoadBillingDataRequested()),
          );
        } else if (state is BillingDataLoaded) {
          return _buildPricingContent(context, state.plans);
        }
         // Default fallback
        return const Center(child: Text('Unexpected state.'));
      },
    );
  }

  Widget _buildPricingContent(BuildContext context, List<Plan> plans) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Simple, Transparent Pricing',
            style: Theme.of(context).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          const Text(
            'Choose the right plan for your API development lifecycle.',
            style: TextStyle(color: Colors.grey, fontSize: 18),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Monthly', style: TextStyle(fontWeight: !_isYearly ? FontWeight.bold : FontWeight.normal)),
              Switch(
                value: _isYearly,
                onChanged: (val) => setState(() => _isYearly = val),
              ),
              Text('Yearly', style: TextStyle(fontWeight: _isYearly ? FontWeight.bold : FontWeight.normal)),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Text('Save 20%', style: TextStyle(color: Colors.green, fontSize: 12, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 48),
          Wrap(
            spacing: 24,
            runSpacing: 24,
            alignment: WrapAlignment.center,
            children: plans.map((plan) => _buildPlanCard(context, plan)).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildPlanCard(BuildContext context, Plan plan) {
    final isPro = plan.name.toLowerCase() == 'pro';
    final price = _isYearly ? plan.yearlyPrice : plan.monthlyPrice;
    final displayPrice = _isYearly ? (price / 12).round() : price; // Show effective monthly

    return Container(
      width: 320,
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(24),
        border: isPro ? Border.all(color: Theme.of(context).colorScheme.primary, width: 2) : Border.all(color: Theme.of(context).dividerColor),
        boxShadow: isPro 
            ? [BoxShadow(color: Theme.of(context).colorScheme.primary.withOpacity(0.2), blurRadius: 20, spreadRadius: 5)] 
            : null,
      ),
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isPro)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text('RECOMMENDED', style: TextStyle(color: Theme.of(context).colorScheme.primary, fontSize: 12, fontWeight: FontWeight.bold)),
            ),
          Text(plan.name, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('₹$displayPrice', style: Theme.of(context).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.bold)),
              const Padding(
                padding: EdgeInsets.only(bottom: 8.0, left: 4.0),
                child: Text('/mo', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          if (_isYearly && price > 0)
             Padding(
               padding: const EdgeInsets.only(top: 8.0),
               child: Text('Billed ₹$price annually', style: const TextStyle(color: Colors.grey, fontSize: 12)),
             ),
          const SizedBox(height: 32),
          _buildFeatureRow('Up to ${plan.maxProjects > 1000 ? 'Unlimited' : plan.maxProjects} API Projects'),
          const SizedBox(height: 16),
          _buildFeatureRow('${plan.maxTestGenerations > 10000 ? 'Unlimited' : plan.maxTestGenerations} Test Generations/mo'),
          if (plan.prioritySupport) ...[
            const SizedBox(height: 16),
            _buildFeatureRow('Priority Support'),
          ],
          const SizedBox(height: 48),
          SizedBox(
            width: double.infinity,
            child: isPro 
              ? FilledButton(
                  onPressed: () {
                    context.read<BillingBloc>().add(StartCheckoutRequested(planId: plan.id, isYearly: _isYearly));
                  },
                  child: const Text('Choose Plan'),
                )
              : OutlinedButton(
                  onPressed: () {
                    context.read<BillingBloc>().add(StartCheckoutRequested(planId: plan.id, isYearly: _isYearly));
                  },
                  child: const Text('Choose Plan'),
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureRow(String text) {
    return Row(
      children: [
        const Icon(Icons.check_circle, color: Colors.green, size: 20),
        const SizedBox(width: 12),
        Expanded(child: Text(text)),
      ],
    );
  }
}
