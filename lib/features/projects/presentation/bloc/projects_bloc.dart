import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/project.dart';
import '../../domain/repositories/project_repository.dart';

part 'projects_event.dart';
part 'projects_state.dart';


class ProjectsBloc extends Bloc<ProjectsEvent, ProjectsState> {
  final ProjectRepository repository;

  ProjectsBloc({required this.repository}) : super(ProjectsInitial()) {
    on<LoadProjectsRequested>(_onLoadProjects);
    on<CreateProjectRequested>(_onCreateProject);
    on<DeleteProjectRequested>(_onDeleteProject);
    on<LoadProjectByIdRequested>(_onLoadProjectById);
  }

  Future<void> _onLoadProjects(LoadProjectsRequested event, Emitter<ProjectsState> emit) async {
    emit(ProjectsLoading());
    try {
      final projects = await repository.getProjects();
      emit(ProjectsLoaded(projects: projects));
    } catch (e) {
      emit(ProjectsError(message: e.toString()));
    }
  }

  Future<void> _onCreateProject(CreateProjectRequested event, Emitter<ProjectsState> emit) async {
    // Save current list if loaded to restore it later
    final currentState = state;
    List<Project> currentProjects = [];
    if (currentState is ProjectsLoaded) {
      currentProjects = currentState.projects;
    }
    
    emit(ProjectsLoading());
    try {
      await repository.createProject(event.name, event.description);
      emit(const ProjectOperationSuccess(message: 'Project created successfully'));
      add(LoadProjectsRequested());
    } catch (e) {
      emit(ProjectsError(message: e.toString()));
      // Restore previous state if needed
      if (currentProjects.isNotEmpty) {
        emit(ProjectsLoaded(projects: currentProjects));
      }
    }
  }

  Future<void> _onDeleteProject(DeleteProjectRequested event, Emitter<ProjectsState> emit) async {
     final currentState = state;
    List<Project> currentProjects = [];
    if (currentState is ProjectsLoaded) {
      currentProjects = currentState.projects;
    }

    emit(ProjectsLoading());
    try {
      await repository.deleteProject(event.id);
      emit(const ProjectOperationSuccess(message: 'Project deleted'));
      add(LoadProjectsRequested());
    } catch (e) {
      emit(ProjectsError(message: e.toString()));
       if (currentProjects.isNotEmpty) {
        emit(ProjectsLoaded(projects: currentProjects));
      }
    }
  }

  Future<void> _onLoadProjectById(LoadProjectByIdRequested event, Emitter<ProjectsState> emit) async {
    emit(ProjectsLoading());
    try {
      final project = await repository.getProjectById(event.id);
      emit(SingleProjectLoaded(project: project));
    } catch (e) {
      emit(ProjectsError(message: e.toString()));
    }
  }
}
