import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moatmat_admin/Features/students/domain/entities/result.dart';
import 'package:moatmat_admin/Presentation/students/state/student/student_cubit.dart';
import 'package:moatmat_admin/Presentation/students/views/student_result_details_v.dart';
import '../../../Core/resources/sizes_resources.dart';
import '../../../Core/widgets/toucheable_tile_widget.dart';
import '../../export/views/results/choose_export_v.dart';
import '../widgets/result_tile_w.dart';
import 'student_reports_view.dart';

class StudentView extends StatefulWidget {
  const StudentView({
    super.key,
    required this.userId,
    this.result,
    required this.userName,
  });
  final String userName;
  final String userId;
  final Result? result;
  @override
  State<StudentView> createState() => _StudentViewState();
}

class _StudentViewState extends State<StudentView> {
  @override
  void initState() {
    context.read<StudentCubit>().init(id: widget.userId, result: widget.result);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<StudentCubit, StudentState>(
        builder: (context, state) {
          if (state is StudentInitial) {
            return Scaffold(
              appBar: AppBar(
                title: Text(
                  state.userData.name,
                  style: const TextStyle(fontSize: 12),
                ),
                actions: [
                  //
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ChooseExportV(
                            results: state.results,
                            name: '',
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.file_open_sharp),
                  ),
                ],
              ),
              body: RefreshIndicator(
                onRefresh: () async {
                  context.read<StudentCubit>().init(id: widget.userId);
                  return;
                },
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 10, bottom: 5),
                      child: Row(
                        children: [
                          Text("رقم الطالب : ${state.userData.id}"),
                        ],
                      ),
                    ),
                    const SizedBox(height: SizesResources.s2),
                    TouchableTileWidget(
                      title: "تصفح تقارير الطالب",
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => StudentReportsView(
                              results: state.results,
                            ),
                          ),
                        );
                      },
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: state.results.length,
                        itemBuilder: (context, index) {
                          return ResultTileWidget(
                            //
                            result: state.results[index],
                            //
                            onExploreResult: () {
                              context.read<StudentCubit>().showResultDetails(state.results[index]);
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else if (state is StudentResultDetails) {
            return StudentResultDetailsView(
              test: state.test,
              bank: state.bank,
              outerTest: state.outerTest,
              testAverage: state.testAverage,
              wrongAnswers: state.wrongAnswers,
              result: state.result,
              userData: state.userData,
            );
          }
          return Scaffold(
            appBar: AppBar(),
            body: const Center(
              child: CupertinoActivityIndicator(),
            ),
          );
        },
      ),
    );
  }
}
