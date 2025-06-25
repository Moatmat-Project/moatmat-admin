import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moatmat_admin/Core/widgets/fields/elevated_button_widget.dart';
import 'package:moatmat_admin/Presentation/notifications/state/send_notification_bloc/send_notification_bloc.dart';

class SendNotificationButton extends StatelessWidget {
  const SendNotificationButton({
    super.key,
    required this.onSend,
  });

  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SendNotificationBloc, SendNotificationState>(
      builder: (context, state) {
        final isLoading = state is SendNotificationLoading;

        return ElevatedButtonWidget(
          onPressed: onSend,
          text: "إرسال الإشعار",
          loading: isLoading,
        );
      },
    );
  }
}
