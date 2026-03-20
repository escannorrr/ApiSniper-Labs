import '../../domain/repositories/user_repository.dart';
import '../datasources/user_remote_datasource.dart';
import '../models/user_profile_model.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remoteDataSource;

  UserRepositoryImpl({required this.remoteDataSource});

  @override
  Future<UserProfile> getProfile() async {
    return await remoteDataSource.getProfile();
  }

  @override
  Future<UserProfile> updateProfile(UpdateProfileRequest request) async {
    return await remoteDataSource.updateProfile(request);
  }

  @override
  Future<void> changePassword(ChangePasswordRequest request) async {
    return await remoteDataSource.changePassword(request);
  }

  @override
  Future<void> deleteAccount() async {
    return await remoteDataSource.deleteAccount();
  }
}
