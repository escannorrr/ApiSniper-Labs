part of 'endpoints_bloc.dart';

abstract class EndpointsState extends Equatable {
  const EndpointsState();
  
  @override
  List<Object?> get props => [];
}

class EndpointsInitial extends EndpointsState {}

class EndpointsLoading extends EndpointsState {}

class EndpointsLoaded extends EndpointsState {
  final List<ApiEndpoint> endpoints;

  const EndpointsLoaded({required this.endpoints});

  @override
  List<Object?> get props => [endpoints];
}

class EndpointsError extends EndpointsState {
  final String message;

  const EndpointsError({required this.message});

  @override
  List<Object?> get props => [message];
}
