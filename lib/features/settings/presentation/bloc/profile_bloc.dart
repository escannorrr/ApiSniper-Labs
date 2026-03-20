import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/user_repository.dart';
import '../../data/models/user_profile_model.dart';
import 'profile_event.dart';
import 'profile_state.dart';

export 'profile_event.dart';
export 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final UserRepository repository;

  ProfileBloc({required this.repository}) : super(ProfileInitial()) {
    on<LoadProfileRequested>(_onLoadProfile);
    on<UpdateProfileRequested>(_onUpdateProfile);
  }

  Future<void> _onLoadProfile(LoadProfileRequested event, Emitter<ProfileState> emit) async {
    emit(ProfileLoading());
    try {
      final profile = await repository.getProfile();
      emit(ProfileLoaded(profile));
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  Future<void> _onUpdateProfile(UpdateProfileRequested event, Emitter<ProfileState> emit) async {
    emit(ProfileUpdating());
    try {
      final request = UpdateProfileRequest(
        name: event.name,
        company: event.company,
        avatarUrl: event.avatarUrl,
      );
      final profile = await repository.updateProfile(request);
      emit(ProfileUpdated(profile));
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }
}
