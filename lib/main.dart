import 'package:firebase_core/firebase_core.dart';
import 'package:moatmat_admin/Presentation/auth/state/auth_c/auth_cubit_cubit.dart';
import 'package:moatmat_admin/Presentation/banks/state/add_bank/add_bank_cubit.dart';
import 'package:moatmat_admin/Presentation/banks/state/my_banks/my_banks_cubit.dart';
import 'package:moatmat_admin/Presentation/banks/state/search_bank/search_bank_cubit.dart';
import 'package:moatmat_admin/Presentation/outer_tests_results/state/cubit/outer_test_results_cubit.dart';
import 'package:moatmat_admin/Presentation/picker/state/cubit/questions_picker_cubit.dart';
import 'package:moatmat_admin/Presentation/questions/state/cubit/create_question_cubit.dart';
import 'package:moatmat_admin/Presentation/requests/state/cubit/requests_cubit.dart';
import 'package:moatmat_admin/Presentation/schools/state/school_bloc/school_bloc.dart';
import 'package:moatmat_admin/Presentation/students/state/my_students/my_students_cubit.dart';
import 'package:moatmat_admin/Presentation/students/state/student_reports/student_reports_cubit.dart';
import 'package:moatmat_admin/Presentation/teachers/state/manage_teacher_purchases/manage_teacher_purchases_bloc.dart';
import 'package:moatmat_admin/Presentation/tests/state/search_test/search_test_cubit.dart';
import 'package:moatmat_admin/firebase_options.dart';
import 'Core/injection/app_inj.dart';
import 'package:flutter/material.dart';
import 'Core/services/supabase_s.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'Presentation/banks/state/bank_information/bank_information_cubit.dart';
import 'Presentation/banks_results/state/cubit/bank_results_cubit.dart';
import 'Presentation/codes/state/codes/codes_cubit.dart';
import 'Presentation/folders/state/add_to_folder/add_to_folder_cubit.dart';
import 'Presentation/folders/state/pick_teacher_item/pick_teacher_item_cubit.dart';
import 'Presentation/groups/state/group_test_detials/group_test_details_cubit.dart';
import 'Presentation/notifications/state/cubit/notifications_cubit.dart';
import 'Presentation/reports/state/reports/reports_cubit.dart';
import 'Presentation/scanner/state/cubit/explore_outer_tests_cubit.dart';
import 'Presentation/teachers/state/teachers_manager/teachers_manager_cubit.dart';
import 'Presentation/students/state/student/student_cubit.dart';
import 'Presentation/tests/state/add_outer_test/add_outer_test_cubit.dart';
import 'Presentation/tests/state/add_test/add_test_cubit.dart';
import 'Presentation/tests/state/my_tests/my_tests_cubit.dart';
import 'Presentation/tests/state/outer_test_information/outer_test_information_cubit.dart';
import 'Presentation/tests/state/test_information/test_information_cubit.dart';
import 'Presentation/tests_results/state/cubit/test_results_cubit.dart';
import 'app_root.dart';

void main() async {
  //
  WidgetsFlutterBinding.ensureInitialized();
  // int supabase
  await SupabaseServices.init();
  //
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // init get it
  await initGetIt();

  //
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AddTestCubit()),
        BlocProvider(create: (context) => MyTestsCubit()),
        BlocProvider(create: (context) => AddBankCubit()),
        BlocProvider(create: (context) => MyBanksCubit()),
        BlocProvider(create: (context) => AuthCubit()),
        BlocProvider(create: (context) => ReportsCubit()..init()),
        BlocProvider(create: (context) => CreateQuestionCubit()),
        BlocProvider(create: (context) => TestInformationCubit()),
        BlocProvider(create: (context) => BankInformationCubit()),
        BlocProvider(create: (context) => TestResultsCubit()),
        BlocProvider(create: (context) => MyStudentsCubit()),
        BlocProvider(create: (context) => StudentCubit()),
        BlocProvider(create: (context) => NotificationsCubit()),
        BlocProvider(create: (context) => BankResultsCubit()),
        BlocProvider(create: (context) => TeachersManagerCubit()),
        BlocProvider(create: (context) => SearchBankCubit()),
        BlocProvider(create: (context) => SearchTestCubit()),
        BlocProvider(create: (context) => CodesCubit()),
        BlocProvider(create: (context) => RequestsCubit()),
        BlocProvider(create: (context) => QuestionsPickerCubit()),
        BlocProvider(create: (context) => ExploreOuterTestsCubit()),
        BlocProvider(create: (context) => AddToFolderCubit()),
        BlocProvider(create: (context) => PickTeacherItemCubit()),
        BlocProvider(create: (context) => OuterTestInformationCubit()),
        BlocProvider(create: (context) => AddOuterTestCubit()),
        BlocProvider(create: (context) => OuterTestResultsCubit()),
        BlocProvider(create: (context) => GroupTestDetailsCubit()),
        BlocProvider(create: (context) => StudentReportsCubit()),
        BlocProvider(create: (context) => ManageTeacherPurchasesBloc()),
        BlocProvider(create: (context) => locator<SchoolBloc>()),
      ],
      child: const AppRoot(),
    ),
  );
}

class ErrorsCopier {
  ///
  // Private constructor for singleton pattern
  ErrorsCopier._privateConstructor();

  // The single instance
  static final ErrorsCopier _instance = ErrorsCopier._privateConstructor();

  // Factory constructor to return the same instance every time
  factory ErrorsCopier() => _instance;

  ///
  final List<String> errors = List.empty(growable: true);

  static List<String> get errorsList => _instance.errors;

  ///
  Future<void> addErrorLogs(String details) async {
    errors.add(details);
  }
}
