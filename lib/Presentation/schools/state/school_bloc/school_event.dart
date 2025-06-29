part of 'school_bloc.dart';

sealed class SchoolEvent extends Equatable {
  const SchoolEvent();

  @override
  List<Object> get props => [];
}

class FetchSchools extends SchoolEvent {}

class AddSchoolEvent extends SchoolEvent {
  final School school;

  const AddSchoolEvent(this.school);

  @override
  List<Object> get props => [school];
}

class UpdateSchoolEvent extends SchoolEvent {
  final School school;

  const UpdateSchoolEvent(this.school);

  @override
  List<Object> get props => [school];
}

class DeleteSchoolEvent extends SchoolEvent {
  final int id;

  const DeleteSchoolEvent(this.id);

  @override
  List<Object> get props => [id];
}
