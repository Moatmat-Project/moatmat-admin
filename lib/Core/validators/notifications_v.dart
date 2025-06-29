String? validateNotificationTitle(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'يرجى إدخال عنوان  ';
  }
  return null;
}
