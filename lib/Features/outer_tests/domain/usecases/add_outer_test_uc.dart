import 'package:dartz/dartz.dart';
import 'package:moatmat_admin/Features/outer_tests/domain/repository/outer_tests_repository.dart';

import '../../../../Core/errors/exceptions.dart';
import '../entities/outer_test.dart';

class AddOuterTestUseCase {
  final OuterTestsRepository repository;

  AddOuterTestUseCase({required this.repository});

  Future<Either<Failure, Unit>> call({required OuterTest test}) async {
    return repository.addOuterTest(test: test);
  }
}
