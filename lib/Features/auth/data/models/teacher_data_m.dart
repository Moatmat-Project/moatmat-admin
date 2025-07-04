import 'package:moatmat_admin/Features/auth/data/models/teacher_options.dart';
import 'package:moatmat_admin/Features/auth/domain/entites/teacher_options.dart';

import '../../../groups/data/models/group_m.dart';
import '../../domain/entites/teacher_data.dart';

class TeacherDataModel extends TeacherData {
  TeacherDataModel({
    required super.name,
    required super.email,
    required super.image,
    required super.description,
    required super.options,
    required super.banksFolders,
    required super.testsFolders,
    required super.price,
    required super.purchaseDescription,
    required super.groups,
  });
  factory TeacherDataModel.fromJson(Map json) {
    return TeacherDataModel(
      name: json["name"],
      email: json["email"],
      description: json["description"],
      image: json["image"],
      price: json["price"] ?? 0,
      purchaseDescription: json["purchase_description"] ?? '',
      banksFolders: json["banks_folders"] ?? {},
      testsFolders: json["tests_folders"] ?? {},
      //
      groups: List.generate((json['groups'] as List?)?.length ?? 0, (i) {
        return GroupModel.fromJson((json['groups'] as List)[i]);
      }),
      //
      options: json["teacher_options"] != null
          ? TeacherOptionsModel.fromJson(
              json["teacher_options"],
            )
          : TeacherOptions(
              allowInsert: false,
              allowUpdate: false,
              allowDelete: false,
              allowScanning: false,
            ),
    );
  }
  factory TeacherDataModel.fromClass(TeacherData teacherData) {
    return TeacherDataModel(
      name: teacherData.name,
      email: teacherData.email,
      price: teacherData.price,
      purchaseDescription: teacherData.purchaseDescription,
      description: teacherData.description,
      image: teacherData.image,
      options: teacherData.options,
      testsFolders: teacherData.testsFolders,
      banksFolders: teacherData.banksFolders,
      groups: teacherData.groups,
    );
  }

  toJson() {
    return {
      "name": name.trim(),
      "email": email.trim(),
      "price": price,
      "description": description,
      "image": image,
      "purchase_description": purchaseDescription,
      "tests_folders": testsFolders,
      "banks_folders": banksFolders,
      "groups": groups.map((e) => GroupModel.fromClass(e).toJson()).toList(),
      "teacher_options": TeacherOptionsModel.fromClass(options).toJson(),
    };
  }
}
