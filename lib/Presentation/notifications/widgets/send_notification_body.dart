import 'dart:io';
import 'package:flutter/material.dart';
import 'package:moatmat_admin/Core/resources/colors_r.dart';
import 'package:moatmat_admin/Core/resources/shadows_r.dart';
import 'package:moatmat_admin/Core/resources/spacing_resources.dart';

import 'package:moatmat_admin/Presentation/notifications/widgets/notification_form_widget.dart';
import 'package:moatmat_admin/Presentation/notifications/widgets/send_notification_button_widget.dart';
import 'package:moatmat_admin/Presentation/notifications/widgets/state_feedback_widget.dart';
import 'package:moatmat_admin/Presentation/notifications/widgets/topic_selector_widget.dart';

class SendNotificationBody extends StatelessWidget {
  final bool isUserMode;
  final File? selectedImage;
  final List<String> selectedUserIds;
  final List<String> selectedTopics;

  final VoidCallback onPickImage;
  final VoidCallback onRemoveImage;
  final VoidCallback onSelectUsers;
  final VoidCallback onSend;
  final Function(bool) onModeChanged;
  final TextEditingController titleController;
  final TextEditingController bodyController;

  const SendNotificationBody({
    super.key,
    required this.isUserMode,
    required this.selectedUserIds,
    required this.selectedImage,
    required this.onPickImage,
    required this.onRemoveImage,
    required this.onSelectUsers,
    required this.onSend,
    required this.onModeChanged,
    required this.titleController,
    required this.bodyController,
    required this.selectedTopics,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: ToggleButtons(
              borderRadius: BorderRadius.circular(4),
              constraints: BoxConstraints.expand(width: SpacingResources.mainWidth(context) / 2),
              isSelected: [isUserMode, !isUserMode],
              selectedColor: ColorsResources.primary,
              onPressed: (index) => onModeChanged(index == 0),
              children: const [
                Padding(padding: EdgeInsets.symmetric(horizontal: 16), child: Text("مستخدمين")),
                Padding(padding: EdgeInsets.symmetric(horizontal: 16), child: Text("مواضيع")),
              ],
            ),
          ),
          const SizedBox(height: 16),
          if (selectedImage != null)
            Padding(
              padding: EdgeInsets.all(SpacingResources.sidePadding),
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(selectedImage!, height: 200, width: double.infinity, fit: BoxFit.cover),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      decoration: BoxDecoration(
                        color: ColorsResources.dangerLight.withAlpha(50),
                        boxShadow: ShadowsResources.mainBoxShadow,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.delete),
                        color: ColorsResources.danger,
                        tooltip: 'إزالة الصورة',
                        onPressed: onRemoveImage,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          NotificationForm(
            isUserMode: isUserMode,
            titleController: titleController,
            bodyController: bodyController,
            pickImage: onPickImage,
          ),
          if (isUserMode)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: SpacingResources.sidePadding, vertical: 8),
              child: Row(
                children: [
                  // "اختر الطلاب" Button
                  Expanded(
                    child: SizedBox(
                      height: 52, // Match the SendNotificationButton height
                      child: ElevatedButton(
                        onPressed: onSelectUsers,
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: ColorsResources.primaryLight,
                          foregroundColor: ColorsResources.darkPrimary,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(24),
                              bottomRight: Radius.circular(24),
                            ),
                          ),
                          textStyle: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(right: 60.0),
                          child: const Text("اختر الطلاب", textAlign: TextAlign.center),
                        ),
                      ),
                    ),
                  ),

                  Container(
                    height: 52,
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    decoration: const BoxDecoration(
                      color: ColorsResources.primaryLight,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(24),
                        bottomLeft: Radius.circular(24),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.group, size: 20, color: ColorsResources.darkPrimary),
                        const SizedBox(width: 6),
                        Padding(
                          padding: const EdgeInsets.only(top: 6.0),
                          child: Text(
                            "${selectedUserIds.length}",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: ColorsResources.darkPrimary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          if (!isUserMode) ...[
            const SizedBox(height: 10),
            TopicSelector(
                onChanged: (topics) => selectedTopics
                  ..clear()
                  ..addAll(topics)),
          ],
          const SizedBox(height: 10),
          SendNotificationButton(onSend: onSend),
          const SizedBox(height: 20),
          const Center(child: StateFeedback()),
        ],
      ),
    );
  }
}
