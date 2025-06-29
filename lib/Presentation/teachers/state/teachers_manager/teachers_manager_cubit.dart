import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:moatmat_admin/Core/injection/app_inj.dart';
import 'package:moatmat_admin/Features/auth/domain/use_cases/get_all_teachers_uc.dart';
import 'package:moatmat_admin/Features/auth/domain/use_cases/update_user_data_uc.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../Features/auth/domain/entites/teacher_data.dart';

part 'teachers_manager_state.dart';

class TeachersManagerCubit extends Cubit<TeachersManagerState> {
  TeachersManagerCubit() : super(TeachersManagerLoading());

  init() async {
    //
    emit(TeachersManagerLoading());
    //
    var res = await locator<GetAllTeachersUC>().call();
    //
    res.fold((l) {
      //
      emit(TeachersManagerError(error: l.toString()));
    }, (r) {
      emit(TeachersManagerInitial(teachers: r));
    });
  }

  update(TeacherData data) async {
    //
    emit(TeachersManagerLoading());
    //
    await locator<UpdateTeacherDataUC>().call(teacherData: data);
    //
    await init();
  }

  add(TeacherData data) async {
    //
    emit(TeachersManagerLoading());
    //
    await locator<UpdateTeacherDataUC>().call(teacherData: data);
    //
    await init();
  }

  delete(String email) async {
    //
    emit(TeachersManagerLoading());
    //
    await Supabase.instance.client.from("teachers_data").delete().eq("email", email);
    //
    await init();
  }
}
