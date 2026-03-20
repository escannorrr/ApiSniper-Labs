import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/api_endpoint.dart';
import '../../domain/repositories/endpoint_repository.dart';

part 'endpoints_event.dart';
part 'endpoints_state.dart';

class EndpointsBloc extends Bloc<EndpointsEvent, EndpointsState> {
  final EndpointRepository repository;

  EndpointsBloc({required this.repository}) : super(EndpointsInitial()) {
    on<LoadEndpointsRequested>(_onLoadEndpoints);
  }

  Future<void> _onLoadEndpoints(LoadEndpointsRequested event, Emitter<EndpointsState> emit) async {
    emit(EndpointsLoading());
    try {
      final endpoints = await repository.getEndpoints(event.projectId);
      emit(EndpointsLoaded(endpoints: endpoints));
    } catch (e) {
      emit(EndpointsError(message: e.toString()));
    }
  }
}
