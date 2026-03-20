import 'package:equatable/equatable.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

class LoadProfileRequested extends ProfileEvent {}

class UpdateProfileRequested extends ProfileEvent {
  final String? name;
  final String? company;
  final String? avatarUrl;

  const UpdateProfileRequested({this.name, this.company, this.avatarUrl});

  @override
  List<Object?> get props => [name, company, avatarUrl];
}
