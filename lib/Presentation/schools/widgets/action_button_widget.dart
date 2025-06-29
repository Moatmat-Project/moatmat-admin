import 'package:flutter/material.dart';
import 'package:moatmat_admin/Core/resources/colors_r.dart';
import 'package:moatmat_admin/Core/resources/fonts_r.dart';
import 'package:moatmat_admin/Core/resources/sizes_resources.dart';
import 'package:moatmat_admin/Core/resources/texts_resources.dart';

class ActionButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color textColor;
  final IconData icon;

  const ActionButton({
    super.key,
    required this.text,
    required this.onPressed,
    required this.backgroundColor,
    required this.textColor,
    required this.icon,
  });

  factory ActionButton.edit({
    required VoidCallback onPressed,
  }) {
    return ActionButton(
      text: TextsResources.edit,
      onPressed: onPressed,
      backgroundColor: ColorsResources.primaryLight,
      textColor: ColorsResources.primary,
      icon: Icons.edit,
    );
  }

  factory ActionButton.delete({
    required VoidCallback onPressed,
  }) {
    return ActionButton(
      text: TextsResources.delete,
      onPressed: onPressed,
      backgroundColor: ColorsResources.dangerLight,
      textColor: ColorsResources.danger,
      icon: Icons.delete_outline,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SizedBox(
        height: SizesResources.s10,
        child: ElevatedButton.icon(
          onPressed: onPressed,
          icon: Icon(
            icon,
            color: textColor,
          ),
          label: Padding(
            padding: const EdgeInsets.only(top: 5.0),
            child: Text(
              text,
              style: FontsResources.styleExtraBold(color: textColor, size: 14),
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: backgroundColor,
            foregroundColor: textColor,
            elevation: 0,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
    );
  }
}
