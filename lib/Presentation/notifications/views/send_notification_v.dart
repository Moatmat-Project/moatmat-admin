import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moatmat_admin/Core/resources/sizes_resources.dart';
import 'package:moatmat_admin/Core/widgets/fields/elevated_button_widget.dart';
import 'package:moatmat_admin/Features/students/domain/entities/user_data.dart';
import 'package:moatmat_admin/Presentation/notifications/state/cubit/notifications_cubit.dart';
import 'package:moatmat_admin/Presentation/notifications/views/write_notification_v.dart';

class SendNotificationView extends StatefulWidget {
  const SendNotificationView({super.key, required this.userData});
  final UserData userData;
  @override
  State<SendNotificationView> createState() => _SendNotificationViewState();
}

class _SendNotificationViewState extends State<SendNotificationView> {
  @override
  void initState() {
    context.read<NotificationsCubit>().emitNotification();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocBuilder<NotificationsCubit, NotificationsState>(
        builder: (context, state) {
          if (state is NotificationsNotification) {
            return WriteNotificationView(
              onSet: (notification) async {
                context.read<NotificationsCubit>().sendNotification(
                      userData: widget.userData,
                      notification: notification,
                    );
              },
            );
          } else if (state is NotificationsSuccess) {
            return Center(
                child: Column(
              children: [
                const Spacer(),
                //
                const Text("تم الارسال بنجاح"),
                //
                const Spacer(),
                //
                ElevatedButtonWidget(
                  text: "موافق",
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                //
                const SizedBox(height: SizesResources.s10),
              ],
            ));
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
