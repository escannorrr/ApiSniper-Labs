import 'package:equatable/equatable.dart';
import '../../../../features/endpoints/domain/entities/api_endpoint.dart';

abstract class ApiSpecState extends Equatable {
  const ApiSpecState();
  
  @override
  List<Object> get props => [];
}

class ApiSpecInitial extends ApiSpecState {}

class ApiSpecUploading extends ApiSpecState {}

class ApiSpecParsed extends ApiSpecState {
  final List<ApiEndpoint> endpoints;
  final String? successMessage;

  const ApiSpecParsed({required this.endpoints, this.successMessage});

  @override
  List<Object> get props => [endpoints, successMessage ?? ''];
}

class EndpointsLoaded extends ApiSpecState {
   final List<ApiEndpoint> endpoints;

  const EndpointsLoaded(this.endpoints);

  @override
  List<Object> get props => [endpoints];
}

class ApiSpecError extends ApiSpecState {
  final String message;

  const ApiSpecError(this.message);

  @override
  List<Object> get props => [message];
}
