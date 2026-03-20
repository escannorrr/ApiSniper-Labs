part of 'projects_bloc.dart';

abstract class ProjectsState extends Equatable {
  const ProjectsState();
  
  @override
  List<Object?> get props => [];
}

class ProjectsInitial extends ProjectsState {}

class ProjectsLoading extends ProjectsState {}

class ProjectsLoaded extends ProjectsState {
  final List<Project> projects;

  const ProjectsLoaded({required this.projects});

  @override
  List<Object?> get props => [projects];
}

class SingleProjectLoaded extends ProjectsState {
  final Project project;

  const SingleProjectLoaded({required this.project});

  @override
  List<Object?> get props => [project];
}

class ProjectsError extends ProjectsState {
  final String message;

  const ProjectsError({required this.message});

  @override
  List<Object?> get props => [message];
}

class ProjectOperationSuccess extends ProjectsState {
  final String message;
  
  const ProjectOperationSuccess({required this.message});

  @override
  List<Object?> get props => [message];
}
