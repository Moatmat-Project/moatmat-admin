import 'package:moatmat_admin/Features/auth/domain/repository/teachers_repository.dart';
import 'package:moatmat_admin/Features/auth/domain/use_cases/get_teacher_data.dart';
import 'package:moatmat_admin/Features/auth/domain/use_cases/get_user_data.dart';
import 'package:moatmat_admin/Features/auth/domain/use_cases/update_user_data_uc.dart';
import 'package:moatmat_admin/Features/notifications/data/datasources/notifications_ds.dart';
import 'package:moatmat_admin/Features/notifications/data/repository/repository_impl.dart';
import 'package:moatmat_admin/Features/notifications/domain/repository/repository.dart';
import 'package:moatmat_admin/Features/notifications/domain/usecases/send_bulk_notification_uc.dart';
import 'package:moatmat_admin/Features/notifications/domain/usecases/send_notification_uc.dart';

import '../../Features/auth/data/data_source/users_ds.dart';
import '../../Features/auth/data/repository/teachers_repository_impl.dart';
import '../../Features/auth/domain/use_cases/sign_in_uc.dart';
import '../../Features/auth/domain/use_cases/sign_up_uc.dart';
import 'app_inj.dart';

injectNotifications() {
  injectDS();
  injectRepo();
  injectUC();
}

void injectUC() {
  locator.registerFactory<SendNotification>(
    () => SendNotification(
      repository: locator(),
    ),
  );
  locator.registerFactory<SendBulkNotification>(
    () => SendBulkNotification(
      repository: locator(),
    ),
  );
}

void injectRepo() {
  locator.registerFactory<NotificationRepository>(
    () => NotificationRepositoryImpl(
      dataSource: locator(),
    ),
  );
}

void injectDS() {
  locator.registerFactory<NotificationDS>(
    () => NotificationDSImpl(),
  );
}
