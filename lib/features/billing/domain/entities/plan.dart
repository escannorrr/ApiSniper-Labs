import 'package:equatable/equatable.dart';

class Plan extends Equatable {
  final String id;
  final String name;
  final int monthlyPrice;
  final int yearlyPrice;
  final int maxProjects;
  final int maxTestGenerations;
  final bool prioritySupport;

  const Plan({
    required this.id,
    required this.name,
    required this.monthlyPrice,
    required this.yearlyPrice,
    required this.maxProjects,
    required this.maxTestGenerations,
    required this.prioritySupport,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        monthlyPrice,
        yearlyPrice,
        maxProjects,
        maxTestGenerations,
        prioritySupport,
      ];
}
