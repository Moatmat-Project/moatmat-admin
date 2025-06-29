import 'package:flutter/material.dart';
import 'package:moatmat_admin/Core/resources/colors_r.dart';
import 'package:moatmat_admin/Core/resources/fonts_r.dart';
import 'package:moatmat_admin/Core/resources/sizes_resources.dart';
import 'package:moatmat_admin/Core/resources/texts_resources.dart';

class SchoolFormHeader extends StatelessWidget {
  final bool isUpdating;
  const SchoolFormHeader({super.key, required this.isUpdating});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: SizesResources.s8 * 2, // 64
          height: SizesResources.s8 * 2, // 64
          decoration: const BoxDecoration(
            color: ColorsResources.primaryLight,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.school_rounded,
            color: ColorsResources.primary,
            size: SizesResources.s8, // 32
          ),
        ),

        const SizedBox(height: SizesResources.s2), // 8
        Text(
          isUpdating ? TextsResources.updateSchoolDetails : TextsResources.enterSchoolDetails,
          style: FontsResources.styleRegular(
            color: ColorsResources.blackText2,
            size: 14,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
