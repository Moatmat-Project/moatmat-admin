import 'package:flutter/material.dart';
import 'package:moatmat_admin/Core/resources/colors_r.dart';

showAlert({
  required BuildContext context,
  required String title,
  required String body,
  required VoidCallback onAgree,
  String? agreeBtn,
  String? disagreeBtn,
}) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: Text(body),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(
            disagreeBtn ?? "إلغاء",
            style: TextStyle(
              color: ColorsResources.blackText2,
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            onAgree();
            Navigator.of(context).pop();
          },
          child: Text(agreeBtn ?? "حسنا"),
        ),
      ],
    ),
  );
}
