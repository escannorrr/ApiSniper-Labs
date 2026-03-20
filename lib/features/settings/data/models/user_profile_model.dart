import 'package:equatable/equatable.dart';

class UserProfile extends Equatable {
  final String id;
  final String email;
  final String name;
  final String? company;
  final String? avatarUrl;

  const UserProfile({
    required this.id,
    required this.email,
    required this.name,
    this.company,
    this.avatarUrl,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'].toString(),
      email: json['email'] ?? '',
      name: json['full_name'] ?? json['name'] ?? '',
      company: json['company'],
      avatarUrl: json['avatar_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'full_name': name,
      'company': company,
      'avatar_url': avatarUrl,
    };
  }

  @override
  List<Object?> get props => [id, email, name, company, avatarUrl];
}

class UpdateProfileRequest extends Equatable {
  final String? name;
  final String? company;
  final String? avatarUrl;

  const UpdateProfileRequest({
    this.name,
    this.company,
    this.avatarUrl,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (name != null) data['full_name'] = name;
    if (company != null) data['company'] = company;
    if (avatarUrl != null) data['avatar_url'] = avatarUrl;
    return data;
  }

  @override
  List<Object?> get props => [name, company, avatarUrl];
}

class ChangePasswordRequest extends Equatable {
  final String currentPassword;
  final String newPassword;

  const ChangePasswordRequest({
    required this.currentPassword,
    required this.newPassword,
  });

  Map<String, dynamic> toJson() {
    return {
      'current_password': currentPassword,
      'new_password': newPassword,
    };
  }

  @override
  List<Object?> get props => [currentPassword, newPassword];
}
