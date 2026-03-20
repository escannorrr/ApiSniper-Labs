part of 'security_analysis_bloc.dart';

abstract class SecurityAnalysisEvent extends Equatable {
  const SecurityAnalysisEvent();

  @override
  List<Object> get props => [];
}

class LoadSecurityIssuesRequested extends SecurityAnalysisEvent {
  final String projectId;

  const LoadSecurityIssuesRequested({required this.projectId});

  @override
  List<Object> get props => [projectId];
}
