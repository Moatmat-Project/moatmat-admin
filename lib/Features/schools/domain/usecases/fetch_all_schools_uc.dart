import 'package:dartz/dartz.dart';
import 'package:moatmat_admin/Core/errors/exceptions.dart';
import 'package:moatmat_admin/Features/schools/domain/entites/school.dart';
import 'package:moatmat_admin/Features/schools/domain/repository/school_repository.dart';

class FetchAllSchoolsUC {
  final SchoolRepository repository;

  FetchAllSchoolsUC(this.repository);

  Future<Either<Failure, List<School>>> call() async {
    return await repository.fetchAllSchools();
  }
}
