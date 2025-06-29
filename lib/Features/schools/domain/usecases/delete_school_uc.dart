import 'package:dartz/dartz.dart';
import 'package:moatmat_admin/Core/errors/exceptions.dart';
import 'package:moatmat_admin/Features/schools/domain/repository/school_repository.dart';

class DeleteSchoolUC {
  final SchoolRepository repository;

  DeleteSchoolUC(this.repository);

  Future<Either<Failure, void>> call(DeleteSchoolParams params) async {
    return await repository.deleteSchool(params.id);
  }
}

class DeleteSchoolParams {
  final int id;

  DeleteSchoolParams({required this.id});
}
