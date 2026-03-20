import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/widgets/app_error.dart';
import '../bloc/billing_bloc.dart';
import '../../domain/entities/payment.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/command_loader.dart';

class BillingManagementScreen extends StatefulWidget {
  const BillingManagementScreen({super.key});

  @override
  State<BillingManagementScreen> createState() => _BillingManagementScreenState();
}

class _BillingManagementScreenState extends State<BillingManagementScreen> {
  @override
  void initState() {
    super.initState();
    context.read<BillingBloc>().add(LoadBillingDataRequested());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BillingBloc, BillingState>(
      builder: (context, state) {
        if (state is BillingLoading || state is BillingInitial) {
          return const CommandLoader(message: 'SYNCHRONIZING WITH FINANCIAL GRID...');
        } else if (state is BillingError) {
          return AppError(
            message: state.message,
            onRetry: () => context.read<BillingBloc>().add(LoadBillingDataRequested()),
          );
        } else if (state is BillingDataLoaded) {
          return _buildContent(context, state);
        }
         return const SizedBox.shrink();
      },
    );
  }

  Widget _buildContent(BuildContext context, BillingDataLoaded state) {
     final currentPlan = state.plans.firstWhere((p) => p.id == state.currentSubscription.planId, orElse: () => state.plans.first);

     return SingleChildScrollView(
       padding: AppSpacing.screenPadding,
       child: Column(
         crossAxisAlignment: CrossAxisAlignment.start,
         children: [
           Row(
             children: [
               const Icon(Icons.account_balance_wallet_outlined, color: AppColors.primaryAccent, size: 24),
               const SizedBox(width: 12),
               Text(
                 'ACTIVE DEPLOYMENT PLAN', 
                 style: AppTextStyles.pageTitle.copyWith(letterSpacing: 2),
               ),
             ],
           ),
           const SizedBox(height: 32),
           Container(
             decoration: BoxDecoration(
               color: AppColors.cardBackground,
               borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
               border: Border.all(color: AppColors.border),
             ),
             child: Padding(
               padding: AppSpacing.cardInsets,
               child: Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                   Row(
                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                     children: [
                       Column(
                         crossAxisAlignment: CrossAxisAlignment.start,
                         children: [
                           Row(
                             children: [
                               Text(
                                 currentPlan.name.toUpperCase(), 
                                 style: AppTextStyles.sectionTitle.copyWith(fontWeight: FontWeight.bold, letterSpacing: 1),
                               ),
                               const SizedBox(width: 16),
                               Container(
                                 padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                 decoration: BoxDecoration(
                                   color: AppColors.primaryAccent.withOpacity(0.1),
                                   borderRadius: BorderRadius.circular(4),
                                   border: Border.all(color: AppColors.primaryAccent.withOpacity(0.3)),
                                 ),
                                 child: Text(
                                   'COMMISSIONED', 
                                   style: AppTextStyles.caption.copyWith(color: AppColors.primaryAccent, fontSize: 10, fontWeight: FontWeight.bold),
                                 ),
                               )
                             ],
                           ),
                           const SizedBox(height: 8),
                           Text(
                             'NEXT CYCLE INVOICE: ${DateFormat('dd MMM yyyy').format(state.currentSubscription.nextBillingDate).toUpperCase()}', 
                             style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary, fontFamily: 'monospace'),
                           ),
                         ],
                       ),
                       Row(
                         children: [
                           OutlinedButton.icon(
                             onPressed: () {
                               context.read<BillingBloc>().add(CancelSubscriptionRequested());
                             },
                             icon: const Icon(Icons.stop_circle_outlined, size: 16, color: AppColors.error),
                             label: const Text('TERMINATE PLAN', style: TextStyle(color: AppColors.error)),
                             style: OutlinedButton.styleFrom(
                               side: const BorderSide(color: AppColors.error),
                             ),
                           ),
                           const SizedBox(width: 16),
                           FilledButton.icon(
                             onPressed: () => context.go('/pricing'),
                             icon: const Icon(Icons.upgrade_outlined, size: 16),
                             label: const Text('UPGRADE ARMAMENT'),
                           ),
                         ],
                       )
                     ],
                   ),
                   const Padding(padding: EdgeInsets.symmetric(vertical: 24), child: Divider(color: AppColors.border)),
                   Row(
                     children: [
                       Expanded(child: _buildLimitIndicator(context, 'MISSION_SLOTS', 1, currentPlan.maxProjects)),
                       const SizedBox(width: 48),
                       Expanded(child: _buildLimitIndicator(context, 'NEURAL_BURSTS', 15, currentPlan.maxTestGenerations)),
                     ],
                   )
                 ],
               ),
             ),
           ),
           const SizedBox(height: 64),
           Row(
             children: [
               const Icon(Icons.history_outlined, color: AppColors.secondaryAccent, size: 24),
               const SizedBox(width: 12),
               Text(
                 'TRANSACTION ARCHIVE', 
                 style: AppTextStyles.pageTitle.copyWith(letterSpacing: 2),
               ),
             ],
           ),
           const SizedBox(height: 24),
           Container(
             decoration: BoxDecoration(
               color: AppColors.cardBackground,
               borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
               border: Border.all(color: AppColors.border),
             ),
             clipBehavior: Clip.antiAlias,
             child: SingleChildScrollView(
               scrollDirection: Axis.horizontal,
               child: DataTable(
                 headingRowColor: WidgetStateProperty.all(AppColors.sidebarBackground),
                 dataRowColor: WidgetStateProperty.all(AppColors.cardBackground),
                 columns: [
                   DataColumn(label: Text('TIMESTAMP', style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.bold))),
                   DataColumn(label: Text('OPERATION', style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.bold))),
                   DataColumn(label: Text('CREDITS', style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.bold))),
                   DataColumn(label: Text('SIGNAL', style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.bold))),
                 ],
                 rows: state.paymentHistory.map((payment) {
                   final planName = state.plans.firstWhere((p) => p.id == payment.planId, orElse: () => state.plans.first).name;
                   final isSuccess = payment.paymentStatus == PaymentStatus.successful;
                   return DataRow(
                     cells: [
                       DataCell(Text(DateFormat('dd MMM yyyy').format(payment.paymentDate).toUpperCase(), style: AppTextStyles.bodyText.copyWith(fontSize: 12, fontFamily: 'monospace'))),
                       DataCell(Text('$planName DEPLOYMENT'.toUpperCase(), style: AppTextStyles.bodyText.copyWith(fontSize: 12))),
                       DataCell(Text('₹${payment.amount}', style: AppTextStyles.bodyText.copyWith(fontSize: 12, fontWeight: FontWeight.bold, fontFamily: 'monospace'))),
                       DataCell(
                         Container(
                           padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                           decoration: BoxDecoration(
                             color: (isSuccess ? AppColors.primaryAccent : AppColors.error).withOpacity(0.1),
                             borderRadius: BorderRadius.circular(4),
                             border: Border.all(color: (isSuccess ? AppColors.primaryAccent : AppColors.error).withOpacity(0.3)),
                           ),
                           child: Text(
                             payment.paymentStatus.name.toUpperCase(), 
                             style: AppTextStyles.caption.copyWith(
                               color: isSuccess ? AppColors.primaryAccent : AppColors.error,
                               fontSize: 10, 
                               fontWeight: FontWeight.bold
                             )
                           ),
                         )
                       ),
                     ]
                   );
                 }).toList(),
               ),
             ),
           ),
         ],
       ),
     );
  }

  Widget _buildLimitIndicator(BuildContext context, String title, int used, int total) {
     final percent = (total == 0) ? 0.0 : (total > 1000 ? 0.0 : used / total);
     final isUnlimited = total > 1000;

     return Column(
       crossAxisAlignment: CrossAxisAlignment.start,
       children: [
         Row(
           mainAxisAlignment: MainAxisAlignment.spaceBetween,
           children: [
             Text(title, style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.bold, letterSpacing: 1, color: AppColors.textPrimary)),
             Text(
               isUnlimited ? '$used / UNLIMITED' : '$used / $total', 
               style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary, fontFamily: 'monospace', fontWeight: FontWeight.bold),
             ),
           ],
         ),
         const SizedBox(height: 12),
         LinearProgressIndicator(
           value: isUnlimited ? 0.05 : percent, 
           color: percent > 0.9 ? AppColors.error : AppColors.primaryAccent,
           backgroundColor: AppColors.border,
           minHeight: 6,
           borderRadius: BorderRadius.circular(3),
         ),
       ],
     );
  }
}
