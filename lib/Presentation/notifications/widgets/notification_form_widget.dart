import 'package:flutter/material.dart';
import 'package:moatmat_admin/Core/resources/colors_r.dart';
import 'package:moatmat_admin/Core/resources/shadows_r.dart';
import 'package:moatmat_admin/Core/resources/spacing_resources.dart';
import 'package:moatmat_admin/Core/validators/notifications_v.dart';
import 'package:moatmat_admin/Core/widgets/fields/text_input_field.dart';

class NotificationForm extends StatefulWidget {
  final bool isUserMode;
  final TextEditingController titleController;
  final TextEditingController bodyController;
  final void Function()? pickImage;

  const NotificationForm({
    super.key,
    required this.isUserMode,
    this.pickImage,
    required this.titleController,
    required this.bodyController,
  });

  @override
  State<NotificationForm> createState() => _NotificationFormState();
}

class _NotificationFormState extends State<NotificationForm> {
  

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Padding(
              padding: EdgeInsets.only(right: SpacingResources.sidePadding),
              child: MyTextFormFieldWidget(
                width: SpacingResources.mainWidth(context) - 52,
                hintText: 'عنوان الإشعار',
                controller: widget.titleController,
                validator: validateNotificationTitle,
              ),
            ),
            const SizedBox(width: 4),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                boxShadow: ShadowsResources.mainBoxShadow,
                color: ColorsResources.primaryLight,
              ),
              child: IconButton(
                color: ColorsResources.primary,
                onPressed: widget.pickImage,
                icon: const Icon(Icons.add_photo_alternate),
                tooltip: 'اختيار صورة',
              ),
            ),
          ],
        ),
        SizedBox(height: 10),
        MyTextFormFieldWidget(
          hintText: 'نص الإشعار',
          controller: widget.bodyController, 
          maxLines: 3,
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
