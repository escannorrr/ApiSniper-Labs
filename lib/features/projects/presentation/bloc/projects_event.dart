part of 'projects_bloc.dart';

abstract class ProjectsEvent extends Equatable {
  const ProjectsEvent();

  @override
  List<Object> get props => [];
}

class LoadProjectsRequested extends ProjectsEvent {}

class CreateProjectRequested extends ProjectsEvent {
  final String name;
  final String description;

  const CreateProjectRequested({required this.name, required this.description});

  @override
  List<Object> get props => [name, description];
}

class DeleteProjectRequested extends ProjectsEvent {
  final String id;

  const DeleteProjectRequested({required this.id});

  @override
  List<Object> get props => [id];
}

class LoadProjectByIdRequested extends ProjectsEvent {
  final String id;

  const LoadProjectByIdRequested({required this.id});

  @override
  List<Object> get props => [id];
}
