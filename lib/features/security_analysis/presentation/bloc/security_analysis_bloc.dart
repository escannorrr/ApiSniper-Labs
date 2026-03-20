import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/security_issue.dart';
import '../../domain/repositories/security_repository.dart';

part 'security_analysis_event.dart';
part 'security_analysis_state.dart';

class SecurityAnalysisBloc extends Bloc<SecurityAnalysisEvent, SecurityAnalysisState> {
  final SecurityRepository repository;

  SecurityAnalysisBloc({required this.repository}) : super(SecurityAnalysisInitial()) {
    on<LoadSecurityIssuesRequested>(_onLoadSecurityIssues);
  }

  Future<void> _onLoadSecurityIssues(LoadSecurityIssuesRequested event, Emitter<SecurityAnalysisState> emit) async {
    emit(SecurityAnalysisLoading());
    try {
      final issues = await repository.getSecurityIssues(event.projectId);
      emit(SecurityAnalysisLoaded(issues: issues));
    } catch (e) {
      emit(SecurityAnalysisError(message: e.toString()));
    }
  }
}
