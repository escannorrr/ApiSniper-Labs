import 'package:equatable/equatable.dart';

class ApiSpec extends Equatable {
  final String id;
  final String projectId;
  final String fileName;
  final String specType; // 'openapi', 'swagger', 'postman'
  final DateTime uploadedAt;

  const ApiSpec({
    required this.id,
    required this.projectId,
    required this.fileName,
    required this.specType,
    required this.uploadedAt,
  });

  @override
  List<Object?> get props => [
        id,
        projectId,
        fileName,
        specType,
        uploadedAt,
      ];
}
