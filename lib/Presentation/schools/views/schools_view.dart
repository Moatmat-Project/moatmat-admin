import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moatmat_admin/Core/functions/show_alert.dart';
import 'package:moatmat_admin/Core/resources/spacing_resources.dart';
import 'package:moatmat_admin/Core/resources/texts_resources.dart';
import 'package:moatmat_admin/Features/schools/domain/entites/school.dart';
import 'package:moatmat_admin/Presentation/schools/state/school_bloc/school_bloc.dart';
import 'package:moatmat_admin/Presentation/schools/widgets/school_card_widget_widget.dart';
import '../widgets/add_school_fab_widget.dart';
import './add_or_update_school_view.dart';

class SchoolsView extends StatefulWidget {
  const SchoolsView({super.key});

  @override
  State<SchoolsView> createState() => _SchoolsViewState();
}

class _SchoolsViewState extends State<SchoolsView> {
  @override
  void initState() {
    context.read<SchoolBloc>().add(FetchSchools());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppBarTitles.schools),
      ),
      body: Padding(
        padding: EdgeInsets.all(SpacingResources.sidePadding),
        child: BlocConsumer<SchoolBloc, SchoolState>(
          listener: (context, state) {
            if (state is SchoolError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            } else if (state is SchoolActionSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );

              context.read<SchoolBloc>().add(FetchSchools());
            }
          },
          builder: (context, state) {
            if (state is SchoolLoading) {
              return const Center(child: CupertinoActivityIndicator());
            } else if (state is SchoolLoaded) {
              if (state.schools.isEmpty) {
                return Center(
                  child: Text(TextsResources.noSchoolsFound),
                );
              }
              return ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: state.schools.length,
                itemBuilder: (context, index) {
                  final school = state.schools[index];
                  return SchoolCard(
                    school: school,
                    onEdit: () => _onEditSchool(context, school),
                    onDelete: () => _onDeleteSchool(context, school),
                  );
                },
              );
            } else if (state is SchoolError) {
              return Center(child: Text('Failed to load schools: ${state.message}'));
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
      floatingActionButton: AddSchoolFab(onPressed: () => _navigateToAddSchool(context)),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  void _onEditSchool(BuildContext context, School school) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => AddOrUpdateSchoolView(school: school)),
    );
  }

  void _onDeleteSchool(BuildContext context, School school) {
    showAlert(
      context: context,
      title: TextsResources.deleteConfirmationTitle,
      body: TextsResources.deleteConfirmationContent,
      onAgree: () {
        context.read<SchoolBloc>().add(DeleteSchoolEvent(school.id));
      },
    );
  }

  void _navigateToAddSchool(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const AddOrUpdateSchoolView(),
      ),
    );
  }
}
