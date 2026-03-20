import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/user_repository.dart';
import '../../data/models/user_profile_model.dart';
import 'account_event.dart';
import 'account_state.dart';

export 'account_event.dart';
export 'account_state.dart';

class AccountBloc extends Bloc<AccountEvent, AccountState> {
  final UserRepository repository;

  AccountBloc({required this.repository}) : super(AccountInitial()) {
    on<ChangePasswordRequested>(_onChangePassword);
    on<DeleteAccountRequested>(_onDeleteAccount);
  }

  Future<void> _onChangePassword(ChangePasswordRequested event, Emitter<AccountState> emit) async {
    emit(AccountLoading());
    try {
      final request = ChangePasswordRequest(
        currentPassword: event.currentPassword,
        newPassword: event.newPassword,
      );
      await repository.changePassword(request);
      emit(const PasswordChangeSuccess('Password changed successfully'));
    } catch (e) {
      emit(AccountError(e.toString()));
    }
  }

  Future<void> _onDeleteAccount(DeleteAccountRequested event, Emitter<AccountState> emit) async {
    emit(AccountLoading());
    try {
      await repository.deleteAccount();
      emit(AccountDeletedSuccess());
    } catch (e) {
      if (e.toString().contains('401')) {
        // If we get a 401 during deletion, it likely means the account is already gone
        // or session is invalidated. Treat as success to allow redirection.
        emit(AccountDeletedSuccess());
      } else {
        emit(AccountError(e.toString()));
      }
    }
  }
}
