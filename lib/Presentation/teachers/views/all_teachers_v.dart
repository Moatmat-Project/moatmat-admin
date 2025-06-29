import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:moatmat_admin/Core/widgets/appbar/report_icon_w.dart';
import 'package:moatmat_admin/Core/widgets/appbar/student_search_icon.dart';
import 'package:moatmat_admin/Core/widgets/toucheable_tile_widget.dart';
import 'package:moatmat_admin/Features/auth/domain/entites/teacher_data.dart';
import 'package:moatmat_admin/Presentation/teachers/state/teachers_manager/teachers_manager_cubit.dart';
import 'package:moatmat_admin/Presentation/teachers/views/add_teacher_v.dart';
import 'package:moatmat_admin/Presentation/teachers/views/update_teacher_v.dart';
import '../../../Core/resources/sizes_resources.dart';
import '../../../Core/widgets/fields/text_input_field.dart';

class AllTeachersView extends StatefulWidget {
  const AllTeachersView({super.key});

  @override
  State<AllTeachersView> createState() => _AllTeachersViewState();
}

class _AllTeachersViewState extends State<AllTeachersView> {
  late TextEditingController _controller;
  List<TeacherData> teachers = [];
  List<TeacherData> search = [];
  @override
  void initState() {
    context.read<TeachersManagerCubit>().init();
    teachers = [];
    //
    search = [];
    //
    _controller = TextEditingController();
    //
    _controller.addListener(() {
      if (_controller.text.isEmpty) {
        search = teachers;
      } else {
        search = teachers.where((e) {
          return e.name.contains(_controller.text);
        }).toList();
      }
      setState(() {});
    });
    //
    super.initState();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("الاساتذة"),

        actions: [
          //   IconButton(
          // onPressed: () async {
          //   try {

          //     final data = await Supabase.instance.client.from('device_tokens').select('*');
          //     debugPrint('Fetched device tokens: ${data.length}');
          //     if (!mounted) return;
          //     if (data == null || data.isEmpty) {
          //       showDialog(
          //         context: context,
          //         builder: (context) => AlertDialog(
          //           title: const Text('Device Tokens'),
          //           content: const Text('No device tokens found.'),
          //           actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK'))],
          //         ),
          //       );
          //       return;
          //     }
          //     // Get all column names from the first row
          //     final columns = (data[0]).keys.toList();
          //     showDialog(
          //       context: context,
          //       builder: (context) => AlertDialog(
          //         title: const Text('Device Tokens Table'),
          //         content: SizedBox(
          //           width: double.maxFinite,
          //           child: SingleChildScrollView(
          //             scrollDirection: Axis.horizontal,
          //             child: SingleChildScrollView(
          //               child: DataTable(
          //                 border: TableBorder.all(color: Colors.black),
          //                 columns: columns.map((col) => DataColumn(label: Text(col))).toList(),
          //                 rows: data
          //                     .map<DataRow>((row) => DataRow(
          //                           cells: columns
          //                               .map((col) => DataCell(Text(row[col]?.toString() ?? '')))
          //                               .toList(),
          //                         ))
          //                     .toList(),
          //               ),
          //             ),
          //           ),
          //         ),
          //         actions: [
          //           TextButton(
          //             onPressed: () => Navigator.pop(context),
          //             child: const Text('Close'),
          //           ),
          //         ],
          //       ),
          //     );
          //   } catch (e) {
          //     debugPrint('Error fetching device tokens: $e');
          //     if (mounted) {
          //       ScaffoldMessenger.of(context).showSnackBar(
          //         SnackBar(
          //           content: Text('Failed to fetch device tokens: $e'),
          //           backgroundColor: Colors.red,
          //         ),
          //       );
          //     }
          //   }
          // },
          // icon: const Icon(Icons.add),
          ///),
          StudentsSearchIconWidget(),
          ReportIconWidget(),
        ],
      ),
      body: BlocConsumer<TeachersManagerCubit, TeachersManagerState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state is TeachersManagerInitial) {
            teachers = state.teachers;
            if (_controller.text.isEmpty) {
              search = teachers;
            }
            return Column(
              children: [
                //
                const SizedBox(height: SizesResources.s2),
                //
                MyTextFormFieldWidget(
                  hintText: "بحث",
                  controller: _controller,
                  textInputAction: TextInputAction.done,
                  maxLines: 1,
                ),
                //
                const SizedBox(height: SizesResources.s2),
                Expanded(
                  child: ListView.builder(
                    itemCount: search.length,
                    itemBuilder: (context, index) {
                      return TouchableTileWidget(
                        title: search[index].name,
                        iconData: Icons.arrow_forward_ios,
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => UpdateTeacherView(
                                teacherData: search[index],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            );
          }

          if (state is TeachersManagerError) {
            return Center(
              child: Text(state.error ?? ""),
            );
          }
          return const Center(
            child: CupertinoActivityIndicator(),
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.menu_home,//Developer Account 1
        children: [
          SpeedDialChild(
            label: "إضافة استاذ",
            child: const Icon(Icons.person),
            onTap: () async {
              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const AddTeacherView(),
                ),
              );
              FocusManager.instance.primaryFocus?.unfocus();
            },
          ),
        ],
      ),
    );
  }
}
