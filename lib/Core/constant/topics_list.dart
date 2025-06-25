class Topic {
  final String showName;
  final String name;

  const Topic({required this.showName, required this.name});
}

const List<Topic> topics = [
  Topic(showName: "الادمن", name: "admin"),
  Topic(showName: "الاساتذة", name: "teachers"),
  Topic(showName: "الطلاب", name: "students"),
  Topic(showName: "الرفع", name: "upload"),
  Topic(showName: "اختبار", name: "test"),
];
