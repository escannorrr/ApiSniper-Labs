import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/generated_test.dart';
import '../../domain/models/test_language.dart';
import '../../domain/repositories/test_repository.dart';

part 'test_generation_event.dart';
part 'test_generation_state.dart';

class TestGenerationBloc extends Bloc<TestGenerationEvent, TestGenerationState> {
  final TestRepository repository;

  TestGenerationBloc({required this.repository}) 
      : super(TestGenerationInitial(selectedLanguage: TestLanguage.defaultLanguage)) {
    on<GenerateTestsRequested>(_onGenerateTests);
    on<ChangeTestLanguage>(_onChangeLanguage);
  }

  void _onChangeLanguage(ChangeTestLanguage event, Emitter<TestGenerationState> emit) {
    emit(TestGenerationInitial(selectedLanguage: event.language));
  }

  Future<void> _onGenerateTests(GenerateTestsRequested event, Emitter<TestGenerationState> emit) async {
    final currentLanguage = state.selectedLanguage;
    emit(TestGenerationLoading(selectedLanguage: currentLanguage));
    try {
      final test = await repository.generateTests(event.projectId, event.language);
      emit(TestGenerationSuccess(test: test, selectedLanguage: currentLanguage));
    } catch (e) {
      emit(TestGenerationFailure(message: e.toString(), selectedLanguage: currentLanguage));
    }
  }
}
