import 'package:equatable/equatable.dart';

enum PaymentStatus { successful, pending, failed }

class Payment extends Equatable {
  final String id;
  final String planId;
  final int amount;
  final DateTime paymentDate;
  final PaymentStatus paymentStatus;

  const Payment({
    required this.id,
    required this.planId,
    required this.amount,
    required this.paymentDate,
    required this.paymentStatus,
  });

  @override
  List<Object?> get props => [id, planId, amount, paymentDate, paymentStatus];
}
