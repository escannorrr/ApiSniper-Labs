import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/project_summary.dart';
import '../../data/datasources/dashboard_remote_datasource.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final DashboardRemoteDataSource dataSource;

  DashboardBloc({required this.dataSource}) : super(DashboardInitial()) {
    on<DashboardLoadRequested>(_onDashboardLoadRequested);
  }

  Future<void> _onDashboardLoadRequested(
    DashboardLoadRequested event,
    Emitter<DashboardState> emit,
  ) async {
    emit(DashboardLoading());
    try {
      final projects = await dataSource.getProjects();
      final stats = await dataSource.getStatistics();
      emit(DashboardLoaded(projects: projects, statistics: stats));
    } catch (e) {
      emit(DashboardFailure(e.toString()));
    }
  }
}
