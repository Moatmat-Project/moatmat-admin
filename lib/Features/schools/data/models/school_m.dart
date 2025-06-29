import 'package:moatmat_admin/Features/schools/data/models/school_information_m.dart';
import 'package:moatmat_admin/Features/schools/domain/entites/school.dart';

class SchoolModel extends School {
  SchoolModel({
    required super.id,
    required SchoolInformationModel super.information,
    required super.createdAt,
  });

  factory SchoolModel.fromJson(Map<String, dynamic> json) {
    return SchoolModel(
      id: json['id'],
      information: SchoolInformationModel.fromJson(json['information']),
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'information': (information as SchoolInformationModel).toJson(),
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory SchoolModel.fromEntity(School school) {
    return SchoolModel(
      id: school.id,
      information: SchoolInformationModel.fromEntity(school.information),
      createdAt: school.createdAt,
    );
  }
}
