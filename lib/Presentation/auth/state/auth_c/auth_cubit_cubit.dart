import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';
import 'package:moatmat_admin/Features/auth/domain/entites/teacher_data.dart';
import 'package:moatmat_admin/Features/auth/domain/use_cases/update_user_data_uc.dart';
import 'package:moatmat_admin/Features/notifications/domain/requests/register_device_token_request.dart';
import 'package:moatmat_admin/Features/notifications/domain/usecases/get_device_token_usecase.dart';
import 'package:moatmat_admin/Features/notifications/domain/usecases/register_device_token_usecase.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../Core/injection/app_inj.dart';
import '../../../../Features/auth/domain/use_cases/get_teacher_data.dart';
import '../../../../Features/update/domain/entites/update_info.dart';
import '../../../../Features/update/domain/usecases/check_update_state_uc.dart';

part 'auth_cubit_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthLoading());
  init() async {
    //
    final res = await locator<CheckUpdateStateUC>().call();
    //
    res.fold(
      (l) {
        emit(const AuthError());
      },
      (r) {
        //
        injectUpdateInfo(r);
        //
        if (r.appVersion < r.currentVersion || r.appVersion < r.minimumVersion) {
          //
          emit(AuthUpdate(updateInfo: r));
          //
        } else {
          //
          var user = Supabase.instance.client.auth.currentUser;
          //
          if (user == null) {
            emit(AuthOnBoarding());
          } else {
            refresh();
          }
          //
        }
      },
    );
    //
  }

  injectUpdateInfo(UpdateInfo info) {
    if (!GetIt.instance.isRegistered<UpdateInfo>()) {
      locator.registerFactory<UpdateInfo>(() => info);
    } else {
      GetIt.instance.unregister<UpdateInfo>();
      locator.registerFactory<UpdateInfo>(() => info);
    }
  }

  void skipUpdate() {
    refresh();
  }

  refresh() async {
    //
    emit(AuthLoading());
    //
    locator<GetTeacherDataUC>().call().then((value) {
      value.fold(
        (l) {
          emit(const AuthError());
        },
        (r) async {
          if ((r.options.isAdmin ?? false) || kDebugMode) {
            await injectTeacherData(r);
            await registerDeviceToken();
            emit(AuthDone());
          } else {
            emit(
              const AuthError(
                error: "حساب غير مصرح \n تواصل على واتساب 0984993813 لتنشيط حسابك",
              ),
            );
          }
        },
      );
    });
  }

  updateUserData(TeacherData teacherData) {
    injectTeacherData(teacherData);
    locator<UpdateTeacherDataUC>().call(teacherData: teacherData).then((value) {
      value.fold(
        (l) => null,
        (r) {
          injectTeacherData(teacherData);
        },
      );
    });
  }

  injectTeacherData(TeacherData teacherData) {
    if (!GetIt.instance.isRegistered<TeacherData>()) {
      locator.registerFactory<TeacherData>(() => teacherData);
    } else {
      GetIt.instance.unregister<TeacherData>();
      locator.registerFactory<TeacherData>(() => teacherData);
    }
  }

  //
  startAuth() async {
    emit(AuthStartAuth());
  }

  //
  startSignIn() async {
    emit(AuthSignIn());
  }

  //
  startSignUp() async {
    emit(AuthSignUP());
  }

  //
  startRessetPassword() async {
    emit(AuthResetPassword());
  }

  //
  startSignOut() async {
    emit(AuthLoading());
    await locator<SupabaseClient>().auth.signOut();
    startAuth();
  }

  //
  finishAuth() async {
    await registerDeviceToken();
    await init();
  }

  //
  registerDeviceToken() async {
    final platform = Platform.isAndroid ? 'android' : 'ios';
    final deviceTokenResult = await locator<GetDeviceTokenUsecase>().call();
    await deviceTokenResult.fold(
      (l) async => debugPrint('Failed to get device token: $l'),
      (deviceToken) async {
        await locator<RegisterDeviceTokenUseCase>().call(
          RegisterDeviceTokenRequest(
            deviceToken: deviceToken,
            platform: platform,
          ),
        );
      },
    );
  }
}
