import '../../domain/entities/security_issue.dart';
import '../../domain/repositories/security_repository.dart';
import '../datasources/security_remote_datasource.dart';

class SecurityRepositoryImpl implements SecurityRepository {
  final SecurityRemoteDataSource remoteDataSource;

  SecurityRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<SecurityIssue>> getSecurityIssues(String projectId) async {
    return await remoteDataSource.getSecurityIssues(projectId);
  }
}
