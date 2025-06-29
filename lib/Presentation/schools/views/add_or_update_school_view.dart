import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:moatmat_admin/Core/resources/texts_resources.dart';
import 'package:moatmat_admin/Core/resources/sizes_resources.dart';
import 'package:moatmat_admin/Core/resources/spacing_resources.dart';
import 'package:moatmat_admin/Core/validators/school_v.dart';
import 'package:moatmat_admin/Core/widgets/fields/text_input_field.dart';
import 'package:moatmat_admin/Features/schools/domain/entites/school.dart';
import 'package:moatmat_admin/Features/schools/domain/entites/school_information.dart';
import 'package:moatmat_admin/Presentation/schools/state/school_bloc/school_bloc.dart';

import 'package:moatmat_admin/Presentation/schools/widgets/school_form_actions_widget.dart';
import 'package:moatmat_admin/Presentation/schools/widgets/school_form_header_widget.dart';

class AddOrUpdateSchoolView extends StatefulWidget {
  final School? school;

  const AddOrUpdateSchoolView({super.key, this.school});

  @override
  State<AddOrUpdateSchoolView> createState() => _AddOrUpdateSchoolViewState();
}

class _AddOrUpdateSchoolViewState extends State<AddOrUpdateSchoolView> {
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _initControllers();
  }

  void _initControllers() {
    _nameController = TextEditingController(text: widget.school?.information.name);
    _descriptionController = TextEditingController(text: widget.school?.information.description);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  bool get _isUpdating => widget.school != null;

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final String name = _nameController.text.trim();
      final String description = _descriptionController.text.trim();

      if (_isUpdating) {
        _updateSchool(name, description);
      } else {
        _addSchool(name, description);
      }

      Navigator.of(context).pop();
    }
  }

  void _addSchool(String name, String description) {
    final newSchool = School(
      // Id for منظر
      id: 11001,
      information: SchoolInformation(name: name, description: description),
      createdAt: DateTime.now(),
    );
    context.read<SchoolBloc>().add(AddSchoolEvent(newSchool));
  }

  void _updateSchool(String name, String description) {
    final updatedSchool = School(
      id: widget.school!.id,
      information: SchoolInformation(name: name, description: description),
      createdAt: widget.school!.createdAt,
    );
    context.read<SchoolBloc>().add(UpdateSchoolEvent(updatedSchool));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isUpdating ? AppBarTitles.updateSchool : AppBarTitles.addSchool),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(SpacingResources.sidePadding),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SchoolFormHeader(isUpdating: _isUpdating),
                const SizedBox(height: SizesResources.s8),
                MyTextFormFieldWidget(
                  controller: _nameController,
                  hintText: TextsResources.enterSchoolName,
                  textAlign: TextAlign.right,
                  validator: validateSchoolName,
                ),
                const SizedBox(height: SizesResources.s5),
                MyTextFormFieldWidget(
                  controller: _descriptionController,
                  hintText: TextsResources.enterSchoolDescription,
                  textAlign: TextAlign.right,
                  maxLines: 3,
                  validator: validateSchoolDescription,
                ),
                const SizedBox(height: SizesResources.s8),
                SchoolFormActions(
                  onCancel: Navigator.of(context).pop,
                  isUpdating: _isUpdating,
                  onSubmit: _submitForm,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
