import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moatmat_admin/Core/widgets/fields/text_input_field.dart';
import 'package:moatmat_admin/Presentation/students/state/my_students/my_students_cubit.dart';

class SelectStudentsView extends StatefulWidget {
  const SelectStudentsView({super.key});

  @override
  State<SelectStudentsView> createState() => _SelectStudentsViewState();
}

class _SelectStudentsViewState extends State<SelectStudentsView> {
  late final TextEditingController _searchController;
  final Set<String> selectedUserIds = {};

  @override
  void initState() {
    _searchController = TextEditingController();
    _searchController.addListener(() {
      context.read<MyStudentsCubit>().search(_searchController.text);
    });
    context.read<MyStudentsCubit>().init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("اختر الطلاب"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(selectedUserIds.toList());
            },
            child: const Text("تأكيد", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: BlocBuilder<MyStudentsCubit, MyStudentsState>(
        builder: (context, state) {
          if (state is MyStudentsInitial) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: MyTextFormFieldWidget(
                    hintText: "بحث",
                    suffix: const Icon(Icons.search),
                    controller: _searchController,
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: state.users.length,
                    itemBuilder: (context, index) {
                      final user = state.users[index];
                      final isSelected = selectedUserIds.contains(user.uuid);
                      return ListTile(
                        leading: Checkbox(
                          value: isSelected,
                          onChanged: (_) {
                            setState(() {
                              isSelected ? selectedUserIds.remove(user.uuid) : selectedUserIds.add(user.uuid);
                            });
                          },
                        ),
                        title: Text(user.name),
                        onTap: () {
                          setState(() {
                            isSelected ? selectedUserIds.remove(user.uuid) : selectedUserIds.add(user.uuid);
                          });
                        },
                      );
                    },
                  ),
                ),
              ],
            );
          }
          return const Center(child: CupertinoActivityIndicator());
        },
      ),
    );
  }
}
