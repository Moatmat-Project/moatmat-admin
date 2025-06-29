import 'package:moatmat_admin/Features/schools/domain/entites/school_information.dart';

class School {
  final int id;
  final SchoolInformation information;
  final DateTime createdAt;

  School({
    required this.id,
    required this.information,
    required this.createdAt,
  });
}
