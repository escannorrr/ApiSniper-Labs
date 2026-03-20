part of 'endpoints_bloc.dart';

abstract class EndpointsEvent extends Equatable {
  const EndpointsEvent();

  @override
  List<Object> get props => [];
}

class LoadEndpointsRequested extends EndpointsEvent {
  final String projectId;

  const LoadEndpointsRequested({required this.projectId});

  @override
  List<Object> get props => [projectId];
}
