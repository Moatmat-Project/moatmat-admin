part of 'add_test_cubit.dart';

sealed class AddTestState extends Equatable {
  const AddTestState();

  @override
  List<Object?> get props => [];
}

final class AddTestLoading extends AddTestState {
  final String? details;

  const AddTestLoading({this.details});
  @override
  List<Object?> get props => [details];
}

final class AddTestDenied extends AddTestState {
  const AddTestDenied();
  @override
  List<Object?> get props => [];
}

final class AddTestError extends AddTestState {
  final Exception exception;

  const AddTestError({required this.exception});

  @override
  List<Object?> get props => [exception];
}

final class AddTestInformation extends AddTestState {
  final List<School> schools;
  final TestInformation? information;

  const AddTestInformation({
    required this.schools,
    required this.information,
  });
  @override
  List<Object?> get props => [information];
}

final class AddTestProperties extends AddTestState {
  final TestProperties? properties;

  const AddTestProperties({required this.properties});

  @override
  List<Object?> get props => [properties];
}

final class AddTestQuestions extends AddTestState {
  final List<Question> questions;

  const AddTestQuestions({required this.questions});
  @override
  List<Object?> get props => [questions];
}

final class AddTestPickFiles extends AddTestState {
  final List<String> files;
  const AddTestPickFiles({required this.files});
  @override
  List<Object?> get props => [files];
}

final class AddTestDone extends AddTestState {}
