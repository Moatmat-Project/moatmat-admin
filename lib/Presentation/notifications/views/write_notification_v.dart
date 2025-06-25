import 'package:flutter/material.dart';
import 'package:moatmat_admin/Core/resources/sizes_resources.dart';
import 'package:moatmat_admin/Core/validators/not_empty_v.dart';
import 'package:moatmat_admin/Core/widgets/fields/elevated_button_widget.dart';
import 'package:moatmat_admin/Core/widgets/fields/text_input_field.dart';
import 'package:moatmat_admin/Features/notifications/domain/entities/notification.dart' as n;

import '../../../Features/notifications/domain/entities/notification.dart';

class WriteNotificationView extends StatefulWidget {
  const WriteNotificationView({super.key, required this.onSet});
  final Function(NotificationData notification) onSet;

  @override
  State<WriteNotificationView> createState() => _WriteNotificationViewState();
}

class _WriteNotificationViewState extends State<WriteNotificationView> {
  final formKey = GlobalKey<FormState>();
  late String title;
  late String body;
  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          //
          const SizedBox(height: SizesResources.s2),
          //
          MyTextFormFieldWidget(
            hintText: "عنوان الإشعار",
            onSaved: (p0) {
              title = p0 ?? "";
            },
            validator: (p0) {
              return notEmptyValidator(text: p0);
            },
          ),
          //
          const SizedBox(height: SizesResources.s2),
          //
          MyTextFormFieldWidget(
            minLines: 1,
            maxLines: 5,
            hintText: "محتوى الإشعار",
            onSaved: (p0) {
              body = p0 ?? "";
            },
            validator: (p0) {
              return notEmptyValidator(text: p0);
            },
          ),
          //
          const SizedBox(height: SizesResources.s2),
          //
          ElevatedButtonWidget(
            text: "ارسال",
            onPressed: () {
              if (formKey.currentState?.validate() ?? false) {
                formKey.currentState?.save();
                //
                var not = NotificationData(
                  id: 0,
                  title: title,
                  content: body,
                  date: DateTime.now(),
                );
                //
                widget.onSet(not);
              }
            },
          ),
        ],
      ),
    );
  }
}
