import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moatmat_admin/Presentation/notifications/state/send_notification_bloc/send_notification_bloc.dart';

class StateFeedback extends StatelessWidget {
  const StateFeedback({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<SendNotificationBloc>().state;
   if (state is SendNotificationFailure) {
      return Text(state.message, style: const TextStyle(color: Colors.red));
    } else if (state is SendNotificationSuccess) {
      return const Text('✔ تم إرسال الإشعار بنجاح', style: TextStyle(color: Colors.green));
    }
    return const SizedBox.shrink();
  }
}
