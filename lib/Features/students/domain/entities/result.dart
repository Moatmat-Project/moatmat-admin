import 'package:excel/excel.dart';

import '../../../../Core/functions/parsers/period_to_text_f.dart';

class Result {
  //
  final int id;
  //
  final String userId;
  //
  final String userNumber;
  //
  final double mark;
  //
  final int? testId;
  //
  final int? bankId;
  //
  final int? outerTestId;
  //
  final int? form;
  //
  final List<int?> answers;
  //
  final List<int?> wrongAnswers;
  //
  final DateTime date;
  //
  final int period;
  //
  final String testName;
  //
  final String userName;
  //
  final double? testAverage;
  //
  final String? teacherEmail;

  Result({
    required this.id,
    required this.userId,
    required this.userNumber,
    required this.testId,
    required this.bankId,
    required this.form,
    required this.outerTestId,
    required this.mark,
    required this.answers,
    required this.wrongAnswers,
    required this.date,
    required this.period,
    required this.testName,
    required this.userName,
    this.testAverage,
    this.teacherEmail,
  });
  Result copyWith({
    int? id,
    String? userId,
    String? userNumber,
    double? mark,
    int? testId,
    int? bankId,
    int? outerTestId,
    int? form,
    List<int?>? answers,
    List<int?>? wrongAnswers,
    DateTime? date,
    int? period,
    String? testName,
    String? userName,
    double? testAverage,
    String? teacherEmail,
  }) {
    return Result(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      userNumber: userNumber ?? this.userNumber,
      mark: mark ?? this.mark,
      testId: testId ?? this.testId,
      bankId: bankId ?? this.bankId,
      outerTestId: outerTestId ?? this.outerTestId,
      form: form ?? this.form,
      answers: answers ?? this.answers,
      wrongAnswers: wrongAnswers ?? this.wrongAnswers,
      date: date ?? this.date,
      period: period ?? this.period,
      testName: testName ?? this.testName,
      userName: userName ?? this.userName,
      testAverage: testAverage ?? this.testAverage,
      teacherEmail: teacherEmail ?? this.teacherEmail,
    );
  }

  //
  List<CellValue> toExcelRow() {
    List<CellValue> cells = [];
    // 1 - id
    cells.add(TextCellValue(userNumber));
    // 2 - name
    cells.add(TextCellValue(userName));
    // 3 - mark
    cells.add(TextCellValue("$mark"));
    // 4 - test id
    cells.add(TextCellValue("${bankId ?? " "}"));
    // 5 - bank id
    cells.add(TextCellValue("${testId ?? " "}"));
    // 6 - wrong answers
    List<int?> answers = [];
    for (int i = 0; i < wrongAnswers.length; i++) {
      if (wrongAnswers[i] == -1) {
        continue;
      } else {
        answers.add(i + 1);
      }
    }
    cells.add(
      TextCellValue(answers.isNotEmpty ? answers.join(' , ') : "بيانات ناقصة"),
    );
    // 7 - date
    cells.add(TextCellValue(date.toString().substring(0, 10)));
    // 8 - time
    cells.add(TextCellValue(date.toString().substring(11, 19)));
    // 9 - period
    cells.add(TextCellValue(periodToTextFunction(period)));
    // 10 - t/b name
    cells.add(TextCellValue(testName));
    //
    return cells;
  }
  //
}
