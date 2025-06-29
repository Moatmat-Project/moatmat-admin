import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moatmat_admin/Core/resources/texts_resources.dart';
import 'package:moatmat_admin/Features/schools/domain/entites/school.dart';
import 'package:moatmat_admin/Features/schools/domain/usecases/add_school_uc.dart';
import 'package:moatmat_admin/Features/schools/domain/usecases/delete_school_uc.dart';
import 'package:moatmat_admin/Features/schools/domain/usecases/fetch_all_schools_uc.dart';
import 'package:moatmat_admin/Features/schools/domain/usecases/update_school_uc.dart';

part 'school_event.dart';
part 'school_state.dart';

class SchoolBloc extends Bloc<SchoolEvent, SchoolState> {
  final FetchAllSchoolsUC _fetchAllSchools;
  final AddSchoolUC _addSchool;
  final UpdateSchoolUC _updateSchool;
  final DeleteSchoolUC _deleteSchool;
  SchoolBloc({
    required FetchAllSchoolsUC fetchAllSchools,
    required AddSchoolUC addSchool,
    required UpdateSchoolUC updateSchool,
    required DeleteSchoolUC deleteSchool,
  })  : _fetchAllSchools = fetchAllSchools,
        _addSchool = addSchool,
        _updateSchool = updateSchool,
        _deleteSchool = deleteSchool,
        super(SchoolInitial()) {
    on<FetchSchools>(_onFetchSchools);
    on<AddSchoolEvent>(_onAddSchool);
    on<UpdateSchoolEvent>(_onUpdateSchool);
    on<DeleteSchoolEvent>(_onDeleteSchool);
  }
  void _onFetchSchools(FetchSchools event, Emitter<SchoolState> emit) async {
    emit(SchoolLoading());
    final result = await _fetchAllSchools.call();
    result.fold(
      (failure) => emit(SchoolError(message: failure.text)),
      (schools) => emit(SchoolLoaded(schools: schools)),
    );
  }

  void _onAddSchool(AddSchoolEvent event, Emitter<SchoolState> emit) async {
    emit(SchoolLoading());
    final result = await _addSchool.call(AddSchoolParams(school: event.school));
    result.fold(
      (failure) => emit(SchoolError(message: failure.text)),
      (school) => emit(SchoolActionSuccess(message: TextsResources.schoolAddedSuccess)),
    );
  }

  void _onUpdateSchool(UpdateSchoolEvent event, Emitter<SchoolState> emit) async {
    emit(SchoolLoading());
    final result = await _updateSchool.call(UpdateSchoolParams(school: event.school));
    result.fold(
      (failure) => emit(SchoolError(message: failure.text)),
      (school) => emit(SchoolActionSuccess(message: TextsResources.schoolUpdatedSuccess)),
    );
  }

  void _onDeleteSchool(DeleteSchoolEvent event, Emitter<SchoolState> emit) async {
    emit(SchoolLoading());
    final result = await _deleteSchool.call(DeleteSchoolParams(id: event.id));
    result.fold(
      (failure) => emit(SchoolError(message: failure.text)),
      (_) => emit(SchoolActionSuccess(message: TextsResources.schoolDeletedSuccess)),
    );
  }
}
