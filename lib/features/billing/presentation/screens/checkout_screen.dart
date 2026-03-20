import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../bloc/billing_bloc.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BillingBloc, BillingState>(
      listener: (context, state) {
         if (state is PaymentSuccessState) {
           context.go('/payment-success');
         } else if (state is BillingError) {
           ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message), backgroundColor: Colors.red));
         }
      },
      builder: (context, state) {
        if (state is CheckoutReady) {
           return _buildCheckoutForm(context, state);
        } else if (state is PaymentProcessing) {
           return const Center(
             child: Column(
               mainAxisSize: MainAxisSize.min,
               children: [
                 CircularProgressIndicator(),
                 SizedBox(height: 24),
                 Text('Securely processing your payment...'),
               ]
             )
           );
        }
        // If we magically land here without ready state, return to pricing
        WidgetsBinding.instance.addPostFrameCallback((_) {
           if (state is! PaymentProcessing && state is! PaymentSuccessState && state is! BillingError) {
               context.go('/pricing');
           }
        });
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildCheckoutForm(BuildContext context, CheckoutReady state) {
     final plan = state.selectedPlan;
     final price = state.isYearly ? plan.yearlyPrice : plan.monthlyPrice;

     return Center(
       child: Container(
         constraints: const BoxConstraints(maxWidth: 500),
         padding: const EdgeInsets.all(32),
         child: Card(
           child: Padding(
             padding: const EdgeInsets.all(32.0),
             child: Column(
               mainAxisSize: MainAxisSize.min,
               crossAxisAlignment: CrossAxisAlignment.stretch,
               children: [
                 const Text('Order Summary', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                 const SizedBox(height: 32),
                 Row(
                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   children: [
                     Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                         Text('${plan.name} Plan', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                         Text(state.isYearly ? 'Billed annually' : 'Billed monthly', style: const TextStyle(color: Colors.grey)),
                       ]
                     ),
                     Text('₹$price', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                   ],
                 ),
                 const Padding(
                   padding: EdgeInsets.symmetric(vertical: 24.0),
                   child: Divider(),
                 ),
                 Row(
                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   children: [
                     const Text('Total Due Today', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                     Text('₹$price', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.green)),
                   ],
                 ),
                 const SizedBox(height: 48),
                 // Mock Card input
                 TextFormField(
                   decoration: const InputDecoration(
                     labelText: 'Card Number',
                     hintText: 'xxxx xxxx xxxx xxxx',
                     prefixIcon: Icon(Icons.credit_card),
                     border: OutlineInputBorder(),
                   ),
                   initialValue: '4242 4242 4242 4242',
                   readOnly: true,
                 ),
                 const SizedBox(height: 16),
                 Row(
                   children: [
                     Expanded(
                       child: TextFormField(
                         decoration: const InputDecoration(
                           labelText: 'Expiry Date',
                           hintText: 'MM/YY',
                           border: OutlineInputBorder(),
                         ),
                         initialValue: '12/26',
                         readOnly: true,
                       ),
                     ),
                     const SizedBox(width: 16),
                     Expanded(
                       child: TextFormField(
                         decoration: const InputDecoration(
                           labelText: 'CVC',
                           hintText: '123',
                           border: OutlineInputBorder(),
                         ),
                         initialValue: '123',
                         readOnly: true,
                       ),
                     ),
                   ],
                 ),
                 const SizedBox(height: 32),
                 FilledButton(
                   onPressed: () {
                     context.read<BillingBloc>().add(ProcessPaymentRequested(planId: plan.id, isYearly: state.isYearly));
                   },
                   style: FilledButton.styleFrom(
                     padding: const EdgeInsets.symmetric(vertical: 20),
                   ),
                   child: Text('Pay ₹$price securely', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                 ),
                 const SizedBox(height: 16),
                 Center(
                   child: TextButton(
                     onPressed: () => context.pop(),
                     child: const Text('Cancel & Return', style: TextStyle(color: Colors.grey)),
                   )
                 )
               ],
             ),
           )
         ),
       ),
     );
  }
}
