import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:moatmat_admin/Features/notifications/domain/entities/app_notification.dart';
import 'package:moatmat_admin/Presentation/notifications/state/send_notification_bloc/send_notification_bloc.dart';
import 'package:moatmat_admin/Presentation/notifications/views/select_students_view.dart';
import 'package:moatmat_admin/Presentation/notifications/widgets/send_notification_body.dart';

class SendNotificationView extends StatefulWidget {
  const SendNotificationView({super.key});

  @override
  State<SendNotificationView> createState() => _SendNotificationViewState();
}

class _SendNotificationViewState extends State<SendNotificationView> {
  final _formKey = GlobalKey<FormState>();

  bool isUserMode = true;
  File? selectedImage;
  final selectedUserIds = <String>[];
  final selectedTopics = <String>[];

  final titleController = TextEditingController();
  final bodyController = TextEditingController();

  @override
  void dispose() {
    titleController.dispose();
    bodyController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final file = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (file != null) {
      setState(() => selectedImage = File(file.path));
    }
  }

  void _removeImage() => setState(() => selectedImage = null);

  Future<void> _selectUsers() async {
    final result = await Navigator.of(context).push<List<String>>(
      MaterialPageRoute(builder: (_) => const SelectStudentsView()),
    );

    if (result != null && result.isNotEmpty) {
      setState(() {
        selectedUserIds.addAll(result.where((id) => !selectedUserIds.contains(id)));
      });
    }
  }

  void _sendNotification(BuildContext context) {
    if (!_formKey.currentState!.validate()) return;

    final title = titleController.text.trim();
    final body = bodyController.text.trim();
    final image = selectedImage;
    final notification = AppNotification(
      id: DateTime.now().millisecondsSinceEpoch,
      date: DateTime.now(),
      title: title,
      body: body,
    );

    if (isUserMode) {
      if (selectedUserIds.isEmpty) {
        _showSnackbar('يرجى اختيار مستخدمين أولاً');
        return;
      }
      context.read<SendNotificationBloc>().add(
            SendNotificationToUsers(
              imageFile: image,
              userIds: selectedUserIds,
              notification: notification,
            ),
          );
    } else {
      context.read<SendNotificationBloc>().add(
            SendNotificationToTopics(
              imageFile: image,
              topics: selectedTopics,
              notification: notification,
            ),
          );
    }
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  void _handleSuccess() {
    _showSnackbar('تم إرسال الإشعار بنجاح');
    setState(() {
      titleController.clear();
      bodyController.clear();
      selectedUserIds.clear();
      selectedImage = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('إرسال إشعار')),
      body: BlocListener<SendNotificationBloc, SendNotificationState>(
        listener: (context, state) {
          if (state is SendNotificationSuccess) {
            _handleSuccess();
          } else if (state is SendNotificationFailure) {
            _showSnackbar(state.message);
          }
        },
        child: Form(
          key: _formKey,
          child: SendNotificationBody(
            isUserMode: isUserMode,
            selectedTopics: selectedTopics,
            selectedUserIds: selectedUserIds,
            selectedImage: selectedImage,
            titleController: titleController,
            bodyController: bodyController,
            onModeChanged: (val) => setState(() => isUserMode = val),
            onPickImage: _pickImage,
            onRemoveImage: _removeImage,
            onSelectUsers: _selectUsers,
            onSend: () => _sendNotification(context),
          ),
        ),
      ),
    );
  }
}
