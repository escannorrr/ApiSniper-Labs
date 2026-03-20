import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/project_repository.dart';
import 'api_spec_event.dart';
import 'api_spec_state.dart';


class ApiSpecBloc extends Bloc<ApiSpecEvent, ApiSpecState> {
  final ProjectRepository repository;

  ApiSpecBloc({required this.repository}) : super(ApiSpecInitial()) {
    on<UploadSpecFile>(_onUploadSpecFile);
    on<PasteSpecJson>(_onPasteSpecJson);
    on<ImportSpecFromUrl>(_onImportSpecFromUrl);
    on<ParseSpec>(_onParseSpec);
    on<LoadEndpointsRequested>(_onLoadEndpoints);
  }

  Future<void> _onUploadSpecFile(UploadSpecFile event, Emitter<ApiSpecState> emit) async {
    emit(ApiSpecUploading());
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
        withData: true,
      );

      if (result != null && result.files.single.bytes != null) {
        // Upload MultipartFile to backend
        final bytes = result.files.single.bytes!;
        final fileName = result.files.single.name;
        
        final multipartFile = MultipartFile.fromBytes(bytes, filename: fileName);
        await repository.uploadSpec(event.projectId, multipartFile);
        
        add(LoadEndpointsRequested(event.projectId));
      } else {
        emit(const ApiSpecError('No file selected or invalid file format'));
      }
    } catch (e) {
      String message = e.toString();
      if (e is DioException && e.response?.data != null) {
        final data = e.response!.data;
        if (data is Map && data.containsKey('detail')) {
          message = data['detail'];
        }
      }
      emit(ApiSpecError(message));
    }
  }

  Future<void> _onPasteSpecJson(PasteSpecJson event, Emitter<ApiSpecState> emit) async {
    if (event.jsonContent.trim().isEmpty) {
      emit(const ApiSpecError('JSON content cannot be empty'));
      return;
    }
    emit(ApiSpecUploading());
    add(ParseSpec(event.projectId, event.jsonContent));
  }

  Future<void> _onImportSpecFromUrl(ImportSpecFromUrl event, Emitter<ApiSpecState> emit) async {
    if (event.url.trim().isEmpty) {
      emit(const ApiSpecError('URL cannot be empty'));
      return;
    }
    emit(ApiSpecUploading());
    try {
      // For URL import, we can send the URL to backend or fetch it and upload it
      // Let's assume the backend has an endpoint for URL import or we just upload the JSON
      // Based on common patterns, we'll fetch it and upload it as a virtual file
      final response = await Dio().get(event.url); // Use Dio for consistency
      if (response.statusCode == 200) {
        final content = jsonEncode(response.data);
        final multipartFile = MultipartFile.fromString(content, filename: 'swagger.json');
        await repository.uploadSpec(event.projectId, multipartFile);
        add(LoadEndpointsRequested(event.projectId));
      } else {
         emit(ApiSpecError('Failed to fetch from URL: ${response.statusCode}'));
      }
    } catch (e) {
       String message = e.toString();
       if (e is DioException && e.response?.data != null) {
         final data = e.response!.data;
         if (data is Map && data.containsKey('detail')) {
           message = data['detail'];
         }
       }
       emit(ApiSpecError(message));
    }
  }

  Future<void> _onParseSpec(ParseSpec event, Emitter<ApiSpecState> emit) async {
    try {
      final multipartFile = MultipartFile.fromString(event.jsonContent, filename: 'spec.json');
      await repository.uploadSpec(event.projectId, multipartFile);
      add(LoadEndpointsRequested(event.projectId));
    } catch (e) {
      String message = e.toString();
      if (e is DioException && e.response?.data != null) {
        final data = e.response!.data;
        if (data is Map && data.containsKey('detail')) {
          message = data['detail'];
        }
      }
      emit(ApiSpecError(message));
    }
  }

  Future<void> _onLoadEndpoints(LoadEndpointsRequested event, Emitter<ApiSpecState> emit) async {
    try {
      final endpoints = await repository.getEndpoints(event.projectId);
      emit(EndpointsLoaded(endpoints));
    } catch (e) {
      emit(ApiSpecError('Error loading endpoints: ${e.toString()}'));
    }
  }
}
