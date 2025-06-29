import 'package:moatmat_admin/Features/auth/domain/repository/teachers_repository.dart';
import 'package:moatmat_admin/Features/auth/domain/use_cases/get_teacher_data.dart';
import 'package:moatmat_admin/Features/auth/domain/use_cases/get_user_data.dart';
import 'package:moatmat_admin/Features/auth/domain/use_cases/update_user_data_uc.dart';

import '../../Features/auth/data/data_source/users_ds.dart';
import '../../Features/auth/data/repository/teachers_repository_impl.dart';
import '../../Features/auth/domain/use_cases/get_all_teachers_uc.dart';
import '../../Features/auth/domain/use_cases/get_users_data_by_ids.dart';
import '../../Features/auth/domain/use_cases/sign_in_uc.dart';
import '../../Features/auth/domain/use_cases/sign_up_uc.dart';
import 'app_inj.dart';

injectAuth() {
  injectDS();
  injectRepo();
  injectUC();
}

void injectUC() {
  locator.registerFactory<SignInUC>(
    () => SignInUC(
      repository: locator(),
    ),
  );
  locator.registerFactory<SignUpUC>(
    () => SignUpUC(
      repository: locator(),
    ),
  );
  locator.registerFactory<GetTeacherDataUC>(
    () => GetTeacherDataUC(
      repository: locator(),
    ),
  );
  locator.registerFactory<UpdateTeacherDataUC>(
    () => UpdateTeacherDataUC(
      repository: locator(),
    ),
  );
  locator.registerFactory<GetUserDataUC>(
    () => GetUserDataUC(
      repository: locator(),
    ),
  );
  locator.registerFactory<GetAllTeachersUC>(
    () => GetAllTeachersUC(
      repository: locator(),
    ),
  );
  locator.registerFactory<GetUsersDataByIdsUC>(
    () => GetUsersDataByIdsUC(
      repository: locator(),
    ),
  );
}

void injectRepo() {
  locator.registerFactory<TeacherRepository>(
    () => TeachersRepositoryImpl(
      dataSource: locator(),
    ),
  );
}

void injectDS() {
  locator.registerFactory<TeachersDataSource>(
    () => TeachersDataSourceImpl(client: locator()),
  );
}
