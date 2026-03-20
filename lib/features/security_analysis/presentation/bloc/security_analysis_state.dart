part of 'security_analysis_bloc.dart';

abstract class SecurityAnalysisState extends Equatable {
  const SecurityAnalysisState();
  
  @override
  List<Object?> get props => [];
}

class SecurityAnalysisInitial extends SecurityAnalysisState {}

class SecurityAnalysisLoading extends SecurityAnalysisState {}

class SecurityAnalysisLoaded extends SecurityAnalysisState {
  final List<SecurityIssue> issues;

  const SecurityAnalysisLoaded({required this.issues});

  @override
  List<Object?> get props => [issues];
}

class SecurityAnalysisError extends SecurityAnalysisState {
  final String message;

  const SecurityAnalysisError({required this.message});

  @override
  List<Object?> get props => [message];
}
