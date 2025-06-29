import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:moatmat_admin/Core/injection/app_inj.dart';
import 'package:moatmat_admin/Core/resources/colors_r.dart';
import 'package:moatmat_admin/Core/resources/sizes_resources.dart';
import 'package:moatmat_admin/Core/resources/spacing_resources.dart';
import 'package:moatmat_admin/Core/resources/texts_resources.dart';
import 'package:moatmat_admin/Core/widgets/appbar/student_search_icon.dart';
import 'package:moatmat_admin/Core/widgets/material_picker_v.dart';
import 'package:moatmat_admin/Core/widgets/toucheable_box_widget.dart';
import 'package:moatmat_admin/Core/widgets/toucheable_tile_widget.dart';
import 'package:moatmat_admin/Presentation/banks/views/add_bank_view.dart';

import 'package:moatmat_admin/Presentation/banks/views/banks_search_result_v.dart';
import 'package:moatmat_admin/Presentation/banks/views/my_banks_v.dart';
import 'package:moatmat_admin/Presentation/codes/views/codes_views_manager.dart';
import 'package:moatmat_admin/Presentation/codes/views/print_students_code_view.dart';
import 'package:moatmat_admin/Presentation/notifications/state/notifications_bloc/notifications_bloc.dart';
import 'package:moatmat_admin/Presentation/notifications/state/send_notification_bloc/send_notification_bloc.dart';
import 'package:moatmat_admin/Presentation/notifications/views/notifications_view.dart';
import 'package:moatmat_admin/Presentation/notifications/views/send_notification_view.dart';
import 'package:moatmat_admin/Presentation/requests/views/requests_view_manager.dart';
import 'package:moatmat_admin/Presentation/schools/views/schools_view.dart';
import 'package:moatmat_admin/Presentation/students/views/add_results_v.dart';
import 'package:moatmat_admin/Presentation/students/views/add_student_balance_v.dart';
import 'package:moatmat_admin/Presentation/teachers/views/add_teacher_v.dart';
import 'package:moatmat_admin/Presentation/teachers/views/all_teachers_v.dart';
import 'package:moatmat_admin/Presentation/tests/views/add_test_vew.dart';
import 'package:moatmat_admin/Presentation/tests/views/my_tests_v.dart';
import 'package:moatmat_admin/Presentation/tests/views/tests_search_result_v.dart';
import '../../../Core/widgets/appbar/report_icon_w.dart';
import '../../banks/views/add_bank_view.dart';
import '../../banks/views/my_banks_v.dart';
import '../../students/views/add_results_v.dart';
import '../../tests/views/add_test_vew.dart';
import '../../tests/views/my_tests_v.dart';
class PagesHolderView extends StatefulWidget {
  const PagesHolderView({super.key});

  @override
  State<PagesHolderView> createState() => _PagesHolderViewState();
}

class _PagesHolderViewState extends State<PagesHolderView> {
  int index = 0;
  late final PageController _pageController;
  @override
  void initState() {
    _pageController = PageController(
      initialPage: index,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (value) {
          index = value;
          setState(() {});
        },
        children: [
          //
          Scaffold(
            appBar: AppBar(
              title: Text(AppBarTitles.home),
              actions: const [
                StudentsSearchIconWidget(),
                ReportIconWidget(),
              ],
            ),
            body: Center(
              child: Column(
                children: [
                  // TouchableTileWidget(
                  //   title: "ادارة المدارس",
                  //   onTap: () {

                  //   },
                  // ),
                  // TouchableTileWidget(
                  //   title: "ادارة الاساتذة",
                  //   onTap: () {

                  //   },
                  // ),
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(10),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => SchoolsView(),
                          ),
                        );
                      },
                      child: SizedBox(
                        width: SpacingResources.mainWidth(context),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(height: SizesResources.s5),
                            Icon(
                              Icons.school_rounded,
                              color: ColorsResources.darkPrimary,
                              size: 50,
                            ),
                            SizedBox(height: SizesResources.s5),
                            Text(
                              "ادارة المدارس",
                              style: TextStyle(
                                fontSize: 19,
                                fontWeight: FontWeight.w500,
                                color: ColorsResources.primary,
                              ),
                            ),
                            SizedBox(height: SizesResources.s5),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(10),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => AllTeachersView(),
                          ),
                        );
                      },
                      child: SizedBox(
                        width: SpacingResources.mainWidth(context),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(height: SizesResources.s5),
                            Icon(
                              Icons.person_pin_rounded,
                              color: ColorsResources.darkPrimary,
                              size: 50,
                            ),
                            SizedBox(height: SizesResources.s5),
                            Text(
                              "ادارة الاساتذة",
                              style: TextStyle(
                                fontSize: 19,
                                fontWeight: FontWeight.w500,
                                color: ColorsResources.primary,
                              ),
                            ),
                            SizedBox(height: SizesResources.s5),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          // const AllTeachersView(),
          //
          MaterialPickerView(
            onPick: (s) {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => MyTestsView(
                  material: s,
                ),
              ));
            },
            onSearch: (p0) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => TestsSearchResultView(keyword: p0),
                ),
              );
            },
          ),
          //
          MaterialPickerView(
            onPick: (s) {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => MyBanksView(material: s),
              ));
            },
            onSearch: (p0) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => BanksSearchResultView(keyword: p0),
                ),
              );
            },
          ),
          //
          const RequestsViewManager(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: ColorsResources.red,
        unselectedItemColor: ColorsResources.borders,
        useLegacyColorScheme: false,
        selectedItemColor: ColorsResources.primary,
        currentIndex: index,
        onTap: (value) {
          _pageController.animateToPage(
            value,
            curve: Curves.easeIn,
            duration: const Duration(milliseconds: 200),
          );
          index = value;
          setState(() {});
        },
        iconSize: 20,
        items: const [
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(Icons.home_filled),
            ),
            label: "الرئيسية",
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(Icons.quiz),
            ),
            label: "اختباراتي",
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(Icons.library_books),
            ),
            label: "بنوكي",
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(Icons.file_copy_sharp),
            ),
            label: "طلبات رفع",
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.menu_home,
        children: [
          SpeedDialChild(
            label: "طباعة اكواد",
            child: const Icon(Icons.picture_as_pdf_outlined),
            onTap: () async {
              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const PrintStudentsCodeView(),
                ),
              );
              FocusManager.instance.primaryFocus?.unfocus();
            },
          ),
          SpeedDialChild(
            label: "انشاء اكواد",
            child: const Icon(Icons.qr_code),
            onTap: () async {
              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const CodesViewManager(),
                ),
              );
              FocusManager.instance.primaryFocus?.unfocus();
            },
          ),
          SpeedDialChild(
            label: "شحن رصيد طالب",
            child: const Icon(Icons.currency_exchange),
            onTap: () async {
              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const AddStudentBalanceView(),
                ),
              );
              FocusManager.instance.primaryFocus?.unfocus();
            },
          ),
          // SpeedDialChild(
          //   label: "إضافة استاذ",
          //   child: const Icon(Icons.person),
          //   onTap: () async {
          //     await Navigator.of(context).push(
          //       MaterialPageRoute(
          //         builder: (context) => const AddTeacherView(),
          //       ),
          //     );
          //     FocusManager.instance.primaryFocus?.unfocus();
          //   },
          // ),
          SpeedDialChild(
            label: "إضافة بنك",
            child: const Icon(Icons.add),
            onTap: () async {
              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const AddBankView(),
                ),
              );
              FocusManager.instance.primaryFocus?.unfocus();
            },
          ),
          SpeedDialChild(
            label: "رفع ملف علامات",
            child: const Icon(Icons.account_tree_outlined),
            onTap: () async {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const AddResultsView(),
                ),
              );
            },
          ),
          SpeedDialChild(
            label: "إضافة أختبار",
            child: const Icon(Icons.person_pin_circle_outlined),
            onTap: () async {
              await Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const AddTestView()),
              );
              FocusManager.instance.primaryFocus?.unfocus();
            },
          ),
          SpeedDialChild(
            label: "إرسال اشعارات",
            child: const Icon(Icons.notification_add),
            onTap: () async {
              await Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => BlocProvider(
                    create: (context) => locator<SendNotificationBloc>(),
                    child: SendNotificationView(),
                  )),
              );
              FocusManager.instance.primaryFocus?.unfocus();
            },
          ),
          SpeedDialChild(
            label: "الاشعارات",
            child: const Icon(Icons.notification_important),
            onTap: () async {
              await Navigator.of(context).push(
                MaterialPageRoute(builder: (context) =>   BlocProvider(
          create: (context) => locator<NotificationsBloc>(),
          child: NotificationsView(),
        ),),
              );
              FocusManager.instance.primaryFocus?.unfocus();
            },
          ),
        ],
      ),
    );
  }
}
