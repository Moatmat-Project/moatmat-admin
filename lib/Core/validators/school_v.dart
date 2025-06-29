import 'package:moatmat_admin/Core/resources/texts_resources.dart';

String? validateSchoolName(String? value) {
  if (value == null || value.trim().isEmpty) {
    return TextsResources.pleaseEnterSchoolName;
  }
  if (value.trim().length < 3) {
    return TextsResources.schoolNameMinLength;
  }
  return null;
}

String? validateSchoolDescription(String? value) {
  if (value == null || value.trim().isEmpty) {
    return TextsResources.pleaseEnterSchoolDescription;
  }
  if (value.trim().length < 10) {
    return TextsResources.schoolDescriptionMinLength;
  }
  return null;
}
