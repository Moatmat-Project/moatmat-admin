import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moatmat_admin/Core/resources/sizes_resources.dart';
import 'package:moatmat_admin/Core/widgets/view/set_questions_v.dart';
import 'package:moatmat_admin/Core/widgets/view/set_information.dart';
import 'package:moatmat_admin/Core/widgets/view/set_properties_v.dart';
import 'package:moatmat_admin/Features/tests/domain/entities/test/test.dart';
import 'package:moatmat_admin/Features/tests/domain/entities/test/test_information.dart';
import 'package:moatmat_admin/Features/tests/domain/entities/test/test_properties.dart';
import 'package:moatmat_admin/Presentation/tests/state/add_test/add_test_cubit.dart';
import '../../../Core/widgets/view/attach_file_v.dart';
import '../../../Core/widgets/view/upload_done_v.dart';
import '../../../Core/widgets/view/upload_error_v.dart';
import '../../questions/view/add_question_v.dart';

class AddTestView extends StatefulWidget {
  const AddTestView({super.key, this.test});
  final Test? test;
  @override
  State<AddTestView> createState() => _AddTestViewState();
}

class _AddTestViewState extends State<AddTestView> {
  @override
  void initState() {
    context.read<AddTestCubit>().init(test: widget.test);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocConsumer<AddTestCubit, AddTestState>(
      listener: (context, state) {
        if (state is AddTestDenied) {
          //
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("غير مسموح لك بالعملية")),
          );
          //
          Navigator.of(context).pop();
        }
      },
      builder: (context, state) {
        if (state is AddTestInformation) {
          return SetInformationView(
            title: state.information?.title,
            classs: state.information?.classs,
            material: state.information?.material,
            password: state.information?.password,
            teacher: state.information?.teacher,
            schoolId: state.information?.schoolId,
            schools: state.schools,
            period: state.information?.period,
            price: state.information?.price,
            video: state.information?.video,
            files: state.information?.files,
            images: state.information?.images,
            previous: state.information?.previous,
            afterSet: ({
              required classs,
              required files,
              required material,
              required password,
              required period,
              previous,
              required price,
              required teacher,
              required schoolId,
              required title,
              required video,
              required images,
            }) {
              var info = TestInformation(
                title: title,
                classs: classs,
                material: material,
                teacher: teacher,
                schoolId: schoolId,
                price: price,
                password: password,
                period: period,
                video: video,
                files: files,
                previous: previous,
                images: images,
              );
              //
              context.read<AddTestCubit>().setTestInformation(
                    information: info,
                  );
            },
          );
        } else if (state is AddTestProperties) {
          return SetPropertiesView(
            exploreAnswers: state.properties?.exploreAnswers ?? true,
            timePerQuestion: state.properties?.timePerQuestion ?? false,
            showAnswers: state.properties?.showAnswers ?? false,
            repeatable: state.properties?.repeatable ?? false,
            visible: state.properties?.visible ?? false,
            scrollable: state.properties?.scrollable ?? false,
            afterSet: ({
              exploreAnswers,
              repeatable,
              showAnswers,
              timePerQuestion,
              visible,
              scrollable,
            }) {
              final properties = TestProperties(
                exploreAnswers: exploreAnswers,
                showAnswers: showAnswers,
                timePerQuestion: timePerQuestion,
                repeatable: repeatable,
                visible: visible,
                scrollable: scrollable,
              );
              //
              context.read<AddTestCubit>().setTestProperties(
                    properties: properties,
                  );
            },
            onPop: () {
              context.read<AddTestCubit>().emitTestInformation();
            },
          );
        } else if (state is AddTestQuestions) {
          return SetQuestionsView(
            questions: state.questions,
            onBack: () {
              context.read<AddTestCubit>().emitTestProperties();
            },
            onAddQuestion: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => AddQuestionView(
                    result: (question) {
                      context.read<AddTestCubit>().setTestQuestions(
                            question: question,
                          );
                    },
                  ),
                ),
              );
            },
            onFinish: () {
              context.read<AddTestCubit>().uploadTest();
            },
            onOpenQuestion: (question, index) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => AddQuestionView(
                    question: question,
                    result: (question) {
                      context.read<AddTestCubit>().updateTestQuestions(
                            question: question,
                            index: index,
                          );
                    },
                  ),
                ),
              );
            },
            onDeleteQuestion: (index) {
              context.read<AddTestCubit>().removeQuestion(index);
            },
          );
        } else if (state is AddTestError) {
          return UploadingError(
            msg: state.exception.toString(),
            onTapButton: () {
              context.read<AddTestCubit>().init();
            },
          );
        } else if (state is AddTestDone) {
          return UploadingDone(
            onTapButton: () {
              Navigator.of(context).pop();
            },
          );
        } else if (state is AddTestLoading) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Text(state.details ?? "sdfds sdf"), const SizedBox(height: SizesResources.s3), const CupertinoActivityIndicator()],
            ),
          );
        } else if (state is AddTestPickFiles) {
          return AttachFileView(
            onPop: () {
              context.read<AddTestCubit>().emitTestInformation();
            },
            onFinish: () {
              context.read<AddTestCubit>().uploadTestRequest();
            },
            onUpdate: (String text, List<String> files) {
              context.read<AddTestCubit>().updateTestRequest(
                    text: text,
                    files: files,
                  );
            },
          );
        } else {
          return const Center(
            child: CupertinoActivityIndicator(),
          );
        }
      },
    ));
  }
}
