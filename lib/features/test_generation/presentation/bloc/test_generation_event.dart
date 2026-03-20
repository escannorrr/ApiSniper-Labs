part of 'test_generation_bloc.dart';

abstract class TestGenerationEvent extends Equatable {
  const TestGenerationEvent();

  @override
  List<Object> get props => [];
}

class GenerateTestsRequested extends TestGenerationEvent {
  final String projectId;
  final String language;

  const GenerateTestsRequested({
    required this.projectId,
    required this.language,
  });

  @override
  List<Object> get props => [projectId, language];
}

class ChangeTestLanguage extends TestGenerationEvent {
  final TestLanguage language;

  const ChangeTestLanguage(this.language);

  @override
  List<Object> get props => [language];
}
