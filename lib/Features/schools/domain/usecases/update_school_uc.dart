import 'package:dartz/dartz.dart';
import 'package:moatmat_admin/Core/errors/exceptions.dart';
import 'package:moatmat_admin/Features/schools/domain/entites/school.dart';
import 'package:moatmat_admin/Features/schools/domain/repository/school_repository.dart';

class UpdateSchoolUC {
  final SchoolRepository repository;

  UpdateSchoolUC(this.repository);

  Future<Either<Failure, School>> call(UpdateSchoolParams params) async {
    return await repository.updateSchool(params.school);
  }
}

class UpdateSchoolParams {
  final School school;

  UpdateSchoolParams({required this.school});
}
