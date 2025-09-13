import 'dart:math';
import '../models/student.dart';

double mean(List<double> arr) =>
    arr.isEmpty ? 0 : arr.reduce((a, b) => a + b) / arr.length;

double median(List<double> arr) {
  if (arr.isEmpty) return 0;
  final sorted = List<double>.from(arr)..sort();
  final mid = sorted.length ~/ 2;
  return (sorted.length % 2 == 1)
      ? sorted[mid]
      : (sorted[mid - 1] + sorted[mid]) / 2;
}

double stddev(List<double> arr) {
  if (arr.length < 2) return 0;
  final m = mean(arr);
  final variance =
      arr.map((x) => (x - m) * (x - m)).reduce((a, b) => a + b) / (arr.length - 1);
  return sqrt(variance);
}

// Composite dropout risk score (0..100)
double dropoutRiskScore(Student s) {
  double attendanceRisk = (100 - s.attendancePercent) * 0.35;
  double networkRisk =
      (s.avgMinutesNetwork14 <= 30) ? 15.0 : max(0, (300 - s.avgMinutesNetwork14) / 300 * 15);
  double lmsRisk = max(0, (20 - s.lmsAccess14) / 20 * 10);
  double nightRisk = s.nightActivityRatio * 100 * 0.15;
  double scholarshipRisk = s.scholarshipTerminated ? 15.0 : 0.0;
  double clubRisk = max(0, (10 - s.clubEngagement) / 10 * 10);
  double incomeModifier = (s.incomeCategory == 0) ? 5.0 : 0.0;

  double raw = attendanceRisk +
      networkRisk +
      lmsRisk +
      nightRisk +
      scholarshipRisk +
      clubRisk +
      incomeModifier;

  return raw.clamp(0, 100);
}
