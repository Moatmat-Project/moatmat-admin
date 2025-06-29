import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moatmat_admin/Presentation/notifications/state/send_notification_bloc/send_notification_bloc.dart';

class StateFeedback extends StatelessWidget {
  const StateFeedback({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<SendNotificationBloc, SendNotificationState>(
      listener: (context, state) {
        if (state is SendNotificationFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ),
          );
        } else if (state is SendNotificationSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('✔ تم إرسال الإشعار بنجاح'),
              backgroundColor: Colors.green,
            ),
          );
        }
      },
      child: const SizedBox.shrink(),
    );
  }
}
