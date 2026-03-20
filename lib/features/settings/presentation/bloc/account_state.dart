import 'package:equatable/equatable.dart';

abstract class AccountState extends Equatable {
  const AccountState();

  @override
  List<Object?> get props => [];
}

class AccountInitial extends AccountState {}

class AccountLoading extends AccountState {}

class PasswordChangeSuccess extends AccountState {
  final String message;
  const PasswordChangeSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class AccountDeletedSuccess extends AccountState {}

class AccountError extends AccountState {
  final String message;
  const AccountError(this.message);

  @override
  List<Object?> get props => [message];
}
