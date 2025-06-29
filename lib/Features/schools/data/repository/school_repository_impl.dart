import 'package:dartz/dartz.dart';
import 'package:moatmat_admin/Core/errors/exceptions.dart';
import 'package:moatmat_admin/Features/schools/data/datasources/school_remote_data_source.dart';
import 'package:moatmat_admin/Features/schools/data/models/school_m.dart';
import 'package:moatmat_admin/Features/schools/domain/entites/school.dart';
import 'package:moatmat_admin/Features/schools/domain/repository/school_repository.dart';

class SchoolRepositoryImpl implements SchoolRepository {
  final SchoolRemoteDataSource remoteDataSource;

  SchoolRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<School>>> fetchAllSchools() async {
    try {
      final remoteSchools = await remoteDataSource.fetchAllSchools();
      return Right(remoteSchools);
    } on ServerException {
      return Left(ServerFailure());
    } on Exception {
      return Left(AnonFailure());
    }
  }

  @override
  Future<Either<Failure, School>> addSchool(School school) async {
    try {
      final schoolModel = SchoolModel.fromEntity(school);
      final addedSchool = await remoteDataSource.addSchool(schoolModel);
      return Right(addedSchool);
    } on ServerException {
      return Left(ServerFailure());
    } on Exception {
      return Left(AnonFailure());
    }
  }

  @override
  Future<Either<Failure, void>> deleteSchool(int id) async {
    try {
      await remoteDataSource.deleteSchool(id);
      return const Right(null);
    } on ServerException {
      return Left(ServerFailure());
    } on Exception {
      return Left(AnonFailure());
    }
  }

  @override
  Future<Either<Failure, School>> updateSchool(School school) async {
    try {
      final schoolModel = SchoolModel.fromEntity(school);
      final updatedSchool = await remoteDataSource.updateSchool(schoolModel);
      return Right(updatedSchool);
    } on ServerException {
      return Left(ServerFailure());
    } on Exception {
      return Left(AnonFailure());
    }
  }
}
