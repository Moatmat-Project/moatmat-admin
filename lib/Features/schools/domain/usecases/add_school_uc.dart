import 'package:dartz/dartz.dart';
import 'package:moatmat_admin/Core/errors/exceptions.dart';
import 'package:moatmat_admin/Features/schools/domain/entites/school.dart';
import 'package:moatmat_admin/Features/schools/domain/repository/school_repository.dart';

class AddSchoolUC {
  final SchoolRepository repository;

  AddSchoolUC(this.repository);

  Future<Either<Failure, School>> call(AddSchoolParams params) async {
    return await repository.addSchool(params.school);
  }
}

class AddSchoolParams {
  final School school;

  AddSchoolParams({required this.school});
}
