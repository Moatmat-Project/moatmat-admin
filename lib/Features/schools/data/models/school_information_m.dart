import 'package:moatmat_admin/Features/schools/domain/entites/school_information.dart';

class SchoolInformationModel extends SchoolInformation {
  SchoolInformationModel({
    required super.name,
    required super.description,
  });

  factory SchoolInformationModel.fromJson(Map<String, dynamic> json) {
    return SchoolInformationModel(
      name: json['name'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
    };
  }

  factory SchoolInformationModel.fromEntity(SchoolInformation information) {
    return SchoolInformationModel(
      name: information.name,
      description: information.description,
    );
  }
}
