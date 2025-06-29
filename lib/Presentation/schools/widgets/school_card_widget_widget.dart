import 'package:flutter/material.dart';
import 'package:moatmat_admin/Core/resources/colors_r.dart';
import 'package:moatmat_admin/Core/resources/fonts_r.dart';
import 'package:moatmat_admin/Core/resources/shadows_r.dart';
import 'package:moatmat_admin/Core/resources/sizes_resources.dart';
import 'package:moatmat_admin/Features/schools/domain/entites/school.dart';
import 'action_button_widget.dart';

class SchoolCard extends StatelessWidget {
  final School school;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const SchoolCard({
    super.key,
    required this.school,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: ShadowsResources.mainBoxShadow,
        color: ColorsResources.onPrimary,
      ),
      margin: EdgeInsets.only(bottom: SizesResources.s2),
      child: Padding(
        padding: EdgeInsets.all(SizesResources.s4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            SizedBox(height: SizesResources.s3),
            _buildDescription(context),
            SizedBox(height: SizesResources.s4),
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            color: ColorsResources.primaryLight,
          ),
          child: Padding(
            padding: EdgeInsets.all(4),
            child: Icon(
              Icons.school_outlined,
              color: ColorsResources.primary,
              size: 28,
            ),
          ),
        ),
        SizedBox(width: SizesResources.s2),
        Expanded(
          child: Text(
            school.information.name,
            style: FontsResources.styleBold(color: ColorsResources.textPrimary, size: 18),
            textAlign: TextAlign.start,
          ),
        ),
      ],
    );
  }

  Widget _buildDescription(BuildContext context) {
    return Text(
      school.information.description,
      style: FontsResources.styleMedium(color: ColorsResources.textSecondary, size: 14),
      textAlign: TextAlign.start,
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        ActionButton.edit(
          onPressed: onEdit,
        ),
        const SizedBox(width: 8),
        ActionButton.delete(
          onPressed: onDelete,
        ),
      ],
    );
  }
}
