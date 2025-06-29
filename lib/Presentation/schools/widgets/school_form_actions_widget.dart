import 'package:flutter/material.dart';
import 'package:moatmat_admin/Core/resources/colors_r.dart';
import 'package:moatmat_admin/Core/resources/fonts_r.dart';
import 'package:moatmat_admin/Core/resources/sizes_resources.dart';
import 'package:moatmat_admin/Core/resources/texts_resources.dart';

class SchoolFormActions extends StatelessWidget {
  final VoidCallback onCancel;
  final VoidCallback onSubmit;
  final bool isUpdating;
  const SchoolFormActions({
    super.key,
    required this.onCancel,
    required this.onSubmit,
    required this.isUpdating,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: SizesResources.s10 * 1.2,
            child: OutlinedButton.icon(
              onPressed: onCancel,
              icon: const Icon(
                Icons.close,
                size: SizesResources.s4 * 1.125,
                color: ColorsResources.blackText2,
              ),
              label: Text(
                TextsResources.cancel,
                style: FontsResources.styleMedium(
                  color: ColorsResources.blackText2,
                  size: 16,
                ),
              ),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: ColorsResources.borders),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(SizesResources.s2 * 1.25),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: SizesResources.s4),
        Expanded(
          child: SizedBox(
            height: SizesResources.s10 * 1.2,
            child: ElevatedButton.icon(
              onPressed: onSubmit,
              icon: Icon(
                isUpdating ? Icons.update : Icons.add,
                size: SizesResources.s4 * 1.125,
                color: ColorsResources.whiteText1,
              ),
              label: Text(
                isUpdating ? TextsResources.update : TextsResources.add,
                style: FontsResources.styleMedium(
                  color: ColorsResources.whiteText1,
                  size: 16,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorsResources.primary,
                foregroundColor: ColorsResources.whiteText1,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(SizesResources.s2 * 1.25),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
