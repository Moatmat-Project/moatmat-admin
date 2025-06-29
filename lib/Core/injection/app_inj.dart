import 'package:get_it/get_it.dart';
import 'package:moatmat_admin/Core/injection/banks_inj.dart';
import 'package:moatmat_admin/Core/injection/buckets_inj.dart';
import 'package:moatmat_admin/Core/injection/groups_inj.dart';
import 'package:moatmat_admin/Core/injection/purchases_inj.dart';
import 'package:moatmat_admin/Core/injection/reports_inj.dart';
import 'package:moatmat_admin/Core/injection/school_inj.dart';
import 'package:moatmat_admin/Core/injection/tests_inj.dart';
import 'package:moatmat_admin/Core/injection/update_inj.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'auth_inj.dart';
import 'codes_inj.dart';
import 'notifications_inj.dart';
import 'outer_tests_inj.dart';
import 'requests_inj.dart';
import 'scanner_inj.dart';
import 'students_inj.dart';

var locator = GetIt.instance;
initGetIt() async {
  //
  var sp = await SharedPreferences.getInstance();
  locator.registerSingleton(sp);
  //

  injectAuth();
  //
  injectTests();
  //
  injectBanks();
  //
  injectOuterTests();
  //
  injectBuckets();
  //
  injectReports();
  //
  purchasesInjector();
  //
  injectRequests();
  //
  injectStudents();
  //
  injectGroups();
  //
  injectNotifications();
  //
  codesInjector();
  //
  injectScanner();
  //
  injectUpdate();
  //
  injectSchools();
}
