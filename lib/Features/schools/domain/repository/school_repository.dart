import 'package:dartz/dartz.dart';
import 'package:moatmat_admin/Core/errors/exceptions.dart';
import 'package:moatmat_admin/Features/schools/domain/entites/school.dart';

abstract class SchoolRepository {
  Future<Either<Failure, List<School>>> fetchAllSchools();
  Future<Either<Failure, School>> addSchool(School school);
  Future<Either<Failure, void>> deleteSchool(int id);
  Future<Either<Failure, School>> updateSchool(School school);
}
