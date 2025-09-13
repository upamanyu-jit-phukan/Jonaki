import 'dart:math';
import '../models/student.dart';

class StudentsDummy {
  static List<Student> generate({int count = 25}) {
    final rnd = Random(42);
    final List<String> depts = ['CSE', 'ECE', 'ME', 'CE', 'BIO'];
    final List<String> gradYears = ['2025', '2026', '2027', '2028'];

    List<Student> students = [];

    for (int i = 0; i < count; i++) {
      final attendance = 40 + rnd.nextInt(61); // 40–100%
      final minutes = 30 + rnd.nextInt(570); // 30–600 mins
      final lms = rnd.nextInt(41); // 0–40 visits
      final night = double.parse((rnd.nextDouble() * 0.4).toStringAsFixed(2));
      final income = rnd.nextInt(3); // 0=low,1=mid,2=high
      final scholarship = rnd.nextBool() && rnd.nextInt(6) == 0; // rare termination
      final clubs = rnd.nextInt(21); // 0–20 engagement
      final name = 'Student ${i + 1}';
      final id = 'SID${1000 + i}';
      final dept = depts[rnd.nextInt(depts.length)];
      final grad = gradYears[rnd.nextInt(gradYears.length)];

      List<int> attendanceTrend =
          List.generate(14, (_) => max(0, attendance + rnd.nextInt(7) - 3));
      List<int> networkTrend =
          List.generate(14, (_) => max(0, minutes + rnd.nextInt(80) - 40));

      students.add(Student(
        name: name,
        scholarId: id,
        department: dept,
        gradYear: grad,
        attendancePercent: attendance,
        avgMinutesNetwork14: minutes,
        lmsAccess14: lms,
        nightActivityRatio: night,
        incomeCategory: income,
        scholarshipTerminated: scholarship,
        clubEngagement: clubs,
        attendanceTrend14: attendanceTrend,
        networkTrend14: networkTrend,
      ));
    }

    return students;
  }
}
