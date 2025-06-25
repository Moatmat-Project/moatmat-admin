import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moatmat_admin/Core/widgets/view/attach_file_v.dart';
import 'package:moatmat_admin/Core/widgets/view/set_questions_v.dart';
import 'package:moatmat_admin/Core/widgets/view/set_information.dart';
import 'package:moatmat_admin/Features/banks/domain/entities/bank.dart';
import 'package:moatmat_admin/Features/banks/domain/entities/bank_information.dart';
import 'package:moatmat_admin/Features/banks/domain/entities/bank_properties.dart';
import 'package:moatmat_admin/Presentation/banks/state/add_bank/add_bank_cubit.dart';
import '../../../Core/widgets/view/set_properties_v.dart';
import '../../../Core/widgets/view/upload_done_v.dart';
import '../../../Core/widgets/view/upload_error_v.dart';
import '../../questions/view/add_question_v.dart';

class AddBankView extends StatefulWidget {
  const AddBankView({super.key, this.bank});
  final Bank? bank;
  @override
  State<AddBankView> createState() => _AddBankViewState();
}

class _AddBankViewState extends State<AddBankView> {
  @override
  void initState() {
    context.read<AddBankCubit>().init(bank: widget.bank);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AddBankCubit, AddBankState>(
        listener: (context, state) {
          if (state is AddBankDenied) {
            //
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("غير مسموح لك بالعملية")),
            );
            //
            Navigator.of(context).pop();
          }
        },
        builder: (context, state) {
          if (state is AddBankInformation) {
              return SetInformationView(
              title: state.information?.title,
              classs: state.information?.classs,
              material: state.information?.material,
              password: null,
              teacher: state.information?.teacher,
              period: null,
              price: state.information?.price,
              video: state.information?.video,
              files: state.information?.files,
              images: state.information?.images,
              isBank: true,
              afterSet: ({
                required classs,
                required files,
                required images,
                required material,
                required password,
                required period,
                previous,
                required price,
                required schoolId,
                required teacher,
                required title,
                required video,
              }) {
                {
                  //
                  var info = BankInformation(
                    title: title,
                    classs: classs,
                    material: material,
                    teacher: teacher,
                    price: price,
                    video: video,
                    files: files,
                    images: images,
                  );
                  //
                  context.read<AddBankCubit>().setBankInformation(
                        information: info,
                      );
                }
              },
            );
          } else if (state is AddBankProperties) {
            return SetPropertiesView(
              isTest: false,
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
                final properties = BankProperties(visible: visible, scrollable: scrollable);
                //
                context.read<AddBankCubit>().setTestProperties(
                      properties: properties,
                    );
              },
              onPop: () {
                context.read<AddBankCubit>().emitBankInformation();
              },
            );
          } else if (state is AddBankQuestions) {
            return SetQuestionsView(
              onBack: () {
                context.read<AddBankCubit>().emitBankProperties();
              },
              isBank: true,
              questions: state.questions,
              onAddQuestion: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => AddQuestionView(
                      result: (question) {
                        context.read<AddBankCubit>().setBankQuestions(
                              question: question,
                            );
                      },
                    ),
                  ),
                );
              },
              onFinish: () {
                context.read<AddBankCubit>().uploadBank();
              },
              onOpenQuestion: (question, index) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => AddQuestionView(
                      question: question,
                      result: (question) {
                        context.read<AddBankCubit>().updateBankQuestions(
                              question: question,
                              index: index,
                            );
                      },
                    ),
                  ),
                );
              },
              onDeleteQuestion: (index) {
                context.read<AddBankCubit>().removeQuestion(index);
              },
            );
          } else if (state is AddBankError) {
            return UploadingError(
              msg: state.exception.toString(),
              onTapButton: () {
                context.read<AddBankCubit>().init();
              },
            );
          } else if (state is AddBankDone) {
            return UploadingDone(
              onTapButton: () {
                Navigator.of(context).pop();
              },
            );
          } else if (state is AddBankLoading) {
            return Center(
              child: state.details == "" || state.details == null ? const CupertinoActivityIndicator() : Text(state.details ?? ""),
            );
          } else if (state is AddBankPickFiles) {
            return AttachFileView(
              onPop: () {
                context.read<AddBankCubit>().emitBankInformation();
              },
              onFinish: () {
                context.read<AddBankCubit>().uploadBankRequest();
              },
              onUpdate: (String text, List<String> files) {
                context.read<AddBankCubit>().updateBankRequest(
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
      ),
    );
  }
}
