import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moatmat_admin/Features/students/domain/entities/user_data.dart';
import 'package:moatmat_admin/Presentation/notifications/state/cubit/notifications_cubit.dart';
import 'package:moatmat_admin/Presentation/notifications/views/write_notification_v.dart';

class SendBulkNotificationView extends StatefulWidget {
  const SendBulkNotificationView({super.key, required this.usersData});
  final List<UserData> usersData;
  @override
  State<SendBulkNotificationView> createState() =>
      _SendBulkNotificationViewState();
}

class _SendBulkNotificationViewState extends State<SendBulkNotificationView> {
  @override
  void initState() {
    context.read<NotificationsCubit>().emitBulkNotification();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocBuilder<NotificationsCubit, NotificationsState>(
        builder: (context, state) {
          if (state is NotificationsBulkNotification) {
            return WriteNotificationView(
              onSet: (notification) async {
                context.read<NotificationsCubit>().sendBulkNotification(
                      userData: widget.usersData,
                      notification: notification,
                    );
              },
            );
          } else if (state is NotificationsSuccess) {
            return const Center(child: Text("تم الارسال بنجاح"));
          } else if (state is NotificationsError) {
            return Center(child: Text(state.error));
          }
          return const Center(
            child: CupertinoActivityIndicator(),
          );
        },
      ),
    );
  }
}
