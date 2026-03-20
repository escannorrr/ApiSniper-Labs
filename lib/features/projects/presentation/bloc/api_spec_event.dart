import 'package:equatable/equatable.dart';

abstract class ApiSpecEvent extends Equatable {
  const ApiSpecEvent();

  @override
  List<Object> get props => [];
}

class UploadSpecFile extends ApiSpecEvent {
  final String projectId;
  
  const UploadSpecFile(this.projectId);

  @override
  List<Object> get props => [projectId];
}

class PasteSpecJson extends ApiSpecEvent {
  final String projectId;
  final String jsonContent;

  const PasteSpecJson(this.projectId, this.jsonContent);

  @override
  List<Object> get props => [projectId, jsonContent];
}

class ImportSpecFromUrl extends ApiSpecEvent {
  final String projectId;
  final String url;

  const ImportSpecFromUrl(this.projectId, this.url);

  @override
  List<Object> get props => [projectId, url];
}

class ParseSpec extends ApiSpecEvent {
  final String projectId;
  final String jsonContent;
  
  const ParseSpec(this.projectId, this.jsonContent);

  @override
  List<Object> get props => [projectId, jsonContent];
}
class LoadEndpointsRequested extends ApiSpecEvent {
  final String projectId;

  const LoadEndpointsRequested(this.projectId);

  @override
  List<Object> get props => [projectId];
}
