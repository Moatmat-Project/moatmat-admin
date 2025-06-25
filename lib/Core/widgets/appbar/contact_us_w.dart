import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moatmat_admin/Core/app/admin_info.dart';
import 'package:moatmat_admin/Core/functions/show_alert.dart';
import 'package:moatmat_admin/Presentation/reports/state/reports/reports_cubit.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../Presentation/reports/view/reports_v.dart';

class ContactUsWidget extends StatefulWidget {
  const ContactUsWidget({super.key});

  @override
  State<ContactUsWidget> createState() => _ContactUsWidgetState();
}

class _ContactUsWidgetState extends State<ContactUsWidget> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReportsCubit, ReportsState>(
      builder: (context, state) {
        return IconButton(
          onPressed: () {
            showAlert(
              context: context,
              title: "الدعم",
              body: "تواصل معنا عن طريق الواتساب",
              onAgree: () async {
                await launchUrl(Uri.parse(AdminInfo.whatsapp));
              },
              agreeBtn: "فتح الواتساب",
            );
          },
          icon: const Stack(
            children: [
              Icon(
                Icons.support,
              ),
              Opacity(
                opacity: 0,
                child: Align(
                  alignment: Alignment.topRight,
                  child: CircleAvatar(
                    radius: 3,
                    backgroundColor: Colors.red,
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
