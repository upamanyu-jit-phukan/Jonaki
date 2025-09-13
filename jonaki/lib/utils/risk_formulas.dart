import '../models/student.dart';

class RiskFormulas {
  static double dropoutRisk(Student s) {
    // Based on factors b–g
    return [
      lateNightRisk(s),
      selfEfficacyRisk(s),
      mentalHealthRisk(s),
      socialIsolationRisk(s),
      financialStressRisk(s),
      academicStressRisk(s),
    ].reduce((a, b) => a + b) /
        6.0;
  }

  static double lateNightRisk(Student s) => s.nightActivityRatio > 0.25 ? 0.8 : 0.2;

  static double selfEfficacyRisk(Student s) => s.lmsAccess14 < 5 ? 0.7 : 0.3;

  static double mentalHealthRisk(Student s) =>
      (s.attendancePercent < 50 && s.clubEngagement < 5) ? 0.8 : 0.3;

  static double socialIsolationRisk(Student s) => s.clubEngagement < 3 ? 0.7 : 0.2;

  static double financialStressRisk(Student s) => s.incomeCategory == 0 ? 0.8 : 0.2;

  static double academicStressRisk(Student s) => s.attendancePercent < 60 ? 0.7 : 0.3;

  static String getFormulaText(String key) {
    switch (key) {
      case "Dropout Risk":
        return "DropoutScore = Avg(b–g risk factors)";
      case "Late-Night Activity":
        return "Risk ∝ NightActivityRatio > 0.25";
      case "Low Self-Efficacy":
        return "Risk ∝ Low LMS usage (<5/14 days)";
      case "Mental Health":
        return "Risk ∝ Low Attendance + Low Club Engagement";
      case "Social Isolation":
        return "Risk ∝ Very Low Club Engagement (<3)";
      case "Financial Stress":
        return "Risk ∝ IncomeCategory == Low";
      case "Academic Stress":
        return "Risk ∝ Attendance < 60%";
      default:
        return "";
    }
  }
}
