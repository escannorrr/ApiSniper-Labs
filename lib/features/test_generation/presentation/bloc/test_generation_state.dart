part of 'test_generation_bloc.dart';

abstract class TestGenerationState extends Equatable {
  final TestLanguage selectedLanguage;

  const TestGenerationState({required this.selectedLanguage});
  
  @override
  List<Object?> get props => [selectedLanguage];
}

class TestGenerationInitial extends TestGenerationState {
  const TestGenerationInitial({required super.selectedLanguage});
}

class TestGenerationLoading extends TestGenerationState {
  const TestGenerationLoading({required super.selectedLanguage});
}

class TestGenerationSuccess extends TestGenerationState {
  final GeneratedTest test;

  const TestGenerationSuccess({
    required this.test,
    required super.selectedLanguage,
  });

  @override
  List<Object?> get props => [test, selectedLanguage];
}

class TestGenerationFailure extends TestGenerationState {
  final String message;

  const TestGenerationFailure({
    required this.message,
    required super.selectedLanguage,
  });

  @override
  List<Object?> get props => [message, selectedLanguage];
}
