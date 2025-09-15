import 'dart:math';

class BranchStats {
  final String branch;
  final int students;
  final int atRisk;

  // Risk factors
  final int digitalOverexposure;
  final int academicStress;
  final int financialStress;

  BranchStats({
    required this.branch,
    required this.students,
    required this.atRisk,
    required this.digitalOverexposure,
    required this.academicStress,
    required this.financialStress,
  });
}

class RiskIndicator {
  final String label;
  final String level; // "Low", "Medium", "High"
  final int value; // percentage
  RiskIndicator({
    required this.label,
    required this.level,
    required this.value,
  });
}

class MockDashboard {
  static final _rnd = Random();

  static List<BranchStats> generateBranches() {
    return [
      BranchStats(
        branch: "CSE",
        students: 320,
        atRisk: 18,
        digitalOverexposure: _rnd.nextInt(100),
        academicStress: _rnd.nextInt(100),
        financialStress: _rnd.nextInt(100),
      ),
      BranchStats(
        branch: "ECE",
        students: 280,
        atRisk: 22,
        digitalOverexposure: _rnd.nextInt(100),
        academicStress: _rnd.nextInt(100),
        financialStress: _rnd.nextInt(100),
      ),
      BranchStats(
        branch: "ME",
        students: 210,
        atRisk: 30,
        digitalOverexposure: _rnd.nextInt(100),
        academicStress: _rnd.nextInt(100),
        financialStress: _rnd.nextInt(100),
      ),
      BranchStats(
        branch: "CE",
        students: 180,
        atRisk: 14,
        digitalOverexposure: _rnd.nextInt(100),
        academicStress: _rnd.nextInt(100),
        financialStress: _rnd.nextInt(100),
      ),
    ];
  }

  static List<RiskIndicator> generateIndicators() {
    final levels = ["Low", "Medium", "High"];
    return [
      RiskIndicator(
          label: "Digital Overexposure",
          level: levels[_rnd.nextInt(3)],
          value: _rnd.nextInt(100)),
      RiskIndicator(
          label: "Self-Efficacy",
          level: levels[_rnd.nextInt(3)],
          value: _rnd.nextInt(100)),
      RiskIndicator(
          label: "Mental Health Risk",
          level: levels[_rnd.nextInt(3)],
          value: _rnd.nextInt(100)),
      RiskIndicator(
          label: "Social Isolation Risk",
          level: levels[_rnd.nextInt(3)],
          value: _rnd.nextInt(100)),
      RiskIndicator(
          label: "Financial Stress",
          level: levels[_rnd.nextInt(3)],
          value: _rnd.nextInt(100)),
      RiskIndicator(
          label: "Academic Stress",
          level: levels[_rnd.nextInt(3)],
          value: _rnd.nextInt(100)),
    ];
  }
}
