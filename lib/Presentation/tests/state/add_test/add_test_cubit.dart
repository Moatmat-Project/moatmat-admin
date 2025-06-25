import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:moatmat_admin/Core/errors/exceptions.dart';
import 'package:moatmat_admin/Features/requests/domain/usecases/send_request_uc.dart';
import 'package:moatmat_admin/Features/schools/domain/usecases/fetch_all_schools_uc.dart';
import 'package:moatmat_admin/Features/tests/domain/entities/test/test.dart';
import 'package:moatmat_admin/Features/tests/domain/entities/test/test_information.dart';
import 'package:moatmat_admin/Features/tests/domain/entities/test/test_properties.dart';
import 'package:moatmat_admin/Features/tests/domain/entities/question/question.dart';
import 'package:moatmat_admin/Features/tests/domain/usecases/update_test_uc.dart';
import 'package:moatmat_admin/main.dart';

import '../../../../Core/injection/app_inj.dart';
import '../../../../Core/services/questions_cash_s.dart';
import '../../../../Features/auth/domain/entites/teacher_data.dart';
import '../../../../Features/requests/domain/entities/request.dart';
import '../../../../Features/schools/domain/entites/school.dart';
import '../../../../Features/tests/domain/usecases/upload_test_uc.dart';

part 'add_test_state.dart';

class AddTestCubit extends Cubit<AddTestState> {
  AddTestCubit() : super(const AddTestLoading());
  Test? test;
  TestInformation? information;
  TestProperties? properties;
  List<Question> questions = [];
  late TeacherRequest request;
  init({Test? test}) {
    //
    emit(const AddTestLoading()); // First state to indicate loading/setup
    //
    this.test = test;
    //
    Future.microtask(() {
      // This enqueues the following code to run after the current event loop tick

      //
      information = test?.information;
      //
      properties = test?.properties;
      //
      questions = [];
      //
      request = TeacherRequest(
        id: 0,
        teacherData: locator<TeacherData>(),
        files: [],
        date: DateTime.now(),
      );
      //

      if (this.test != null && information != null) {
        information = information!.copyWith(
          teacher: this.test?.teacherEmail,
        );
      }
      //
      if (test != null) {
        for (int i = 0; i < test.questions.length; i++) {
          questions.add(test.questions[i].copyWith(id: i + 1));
        }
        QuestionsCashS.clearQuestions("test");
      }

      //
      emitTestInformation();
    });
  }

  // cash
  loadQuestions() async {
    //
    emit(const AddTestLoading());
    //
    questions = await QuestionsCashS.loadQuestions("test");
    //
    emitTestQuestions();
  }

  // actions
  setTestInformation({required TestInformation information}) {
    this.information = information;
    emitTestProperties();
  }

  setTestProperties({required TestProperties properties}) {
    this.properties = properties;

    emitTestQuestions();
  }

  setTestQuestions({required Question question}) {
    List<Question> newList = List<Question>.from(questions)..add(question);
    questions = newList;
    //
    QuestionsCashS.cashQuestions(questions, "test");
    //
    emit(AddTestQuestions(questions: newList));
  }

  updateTestQuestions({required Question question, required int index}) {
    questions[index] = question;

    List<Question> newList = [];
    //
    for (int i = 0; i < questions.length; i++) {
      newList.add(questions[i].copyWith(id: i + 1));
    }
    questions = newList;

    emit(AddTestQuestions(questions: newList));
  }

  removeQuestion(int index) {
    questions.removeAt(index);
    List<Question> newList = List<Question>.from(questions);
    questions = newList;
    emit(AddTestQuestions(questions: newList));
  }

  //
  uploadTest() async {
    emit(const AddTestLoading());
    //
    if (test != null) {
      test = test!.copyWith(
        id: test!.id,
        teacherEmail: information!.teacher,
        information: information!,
        properties: properties!,
        questions: questions,
      );
      // upload test information
      var res = await locator<UpdateTestUC>().call(test: test!);
      //
      res.fold(
        (l) => emit(AddTestError(exception: l)),
        (r) async {
          await for (var b in r) {
            emit(AddTestLoading(details: b));
          }
          emit(AddTestDone());
        },
      );
    } else {
      test = Test(
        id: 0,
        teacherEmail: information!.teacher,
        information: information!,
        properties: properties!,
        questions: questions,
      );
      // upload test information
      var res = await locator<UploadTestUC>().call(test: test!);
      //
      res.fold(
        (l) => emit(AddTestError(exception: l)),
        (r) async {
          await for (var b in r) {
            emit(AddTestLoading(details: b));
          }
          emit(AddTestDone());
        },
      );
    }
    await Clipboard.setData(ClipboardData(text: ErrorsCopier.errorsList.toString()));
    //s
  }

  //
  updateTestRequest({required String text, required List<String> files}) {
    request = request.copyWith(
      files: files,
      text: text,
    );
  }

  //
  uploadTestRequest() async {
    //
    test = Test(
      id: 0,
      teacherEmail: information!.teacher,
      information: information!,
      properties: properties!,
      questions: [],
    );
    //
    emit(const AddTestLoading());
    //
    request = request.copyWith(test: test);
    //
    var res = await locator<SendRequestUC>().call(request);
    //
    res.fold((l) => emit(AddTestError(exception: l)), (r) async {
      await for (var msg in r) {
        emit(AddTestLoading(details: msg));
      }
      emit(AddTestDone());
    });
  }

  // views
  Future<void> emitTestInformation() async {
    final response = await locator<FetchAllSchoolsUC>().call();
    response.fold(
      (l) {
        emit(AddTestError(exception: AnonException()));
      },
      (r) {
        emit(AddTestInformation(information: information, schools: r));
      },
    );
  }

  emitTestProperties() {
    emit(AddTestProperties(properties: properties));
  }

  emitTestQuestions() {
    //
    if (!locator<TeacherData>().options.allowInsert && test == null) {
      emit(AddTestPickFiles(files: request.files));
      return;
    }
    //
    List<Question> newQuestions = List<Question>.from(questions);
    emit(AddTestQuestions(questions: newQuestions));
  }
}
