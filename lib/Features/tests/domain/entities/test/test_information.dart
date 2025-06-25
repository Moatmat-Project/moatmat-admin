
import '../mini_test.dart';

class TestInformation {
  final String title;
  final String classs;
  final String material;
  final String teacher;
  final String? schoolId;
  final int? price;
  final String? password;
  final int? period;
  final List<String>? images;
  final List<String>? video;
  final List<String>? files;
  final MiniTest? previous;

  TestInformation({
    required this.title,
    required this.classs,
    required this.material,
    required this.teacher,
    required this.schoolId,
    required this.price,
    required this.password,
    required this.period,
    required this.images,
    required this.video,
    required this.files,
    required this.previous,
  });
  TestInformation copyWith({
    String? title,
    String? classs,
    String? material,
    String? teacher,
    String? schoolId,
    int? price,
    String? password,
    int? period,
    List<String>? video,
    List<String>? images,
    List<String>? files,
    MiniTest? previous,
  }) {
    return TestInformation(
      title: title ?? this.title,
      classs: classs ?? this.classs,
      material: material ?? this.material,
      teacher: teacher ?? this.teacher,
      schoolId: schoolId ?? this.schoolId,
      price: price ?? this.price,
      password: password ?? this.password,
      period: period ?? this.period,
      video: video ?? this.video,
      images: images ?? this.images,
      files: files ?? this.files,
      previous: previous ?? this.previous,
    );
  }
}
