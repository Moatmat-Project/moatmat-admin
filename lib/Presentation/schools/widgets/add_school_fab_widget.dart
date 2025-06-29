import 'package:flutter/material.dart';
import 'package:moatmat_admin/Core/resources/colors_r.dart';

class AddSchoolFab extends StatelessWidget {
  final VoidCallback onPressed;

  const AddSchoolFab({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: FloatingActionButton(
        onPressed: onPressed,
        backgroundColor: ColorsResources.primary,
        foregroundColor: Colors.white,
        elevation: 4,
        child: const Icon(Icons.add, size: 28),
      ),
    );
  }
}
