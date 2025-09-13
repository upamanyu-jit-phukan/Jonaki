class Student {
  final String name;
  final String scholarId;
  final String department;
  final String gradYear;
  final int attendancePercent;
  final int avgMinutesNetwork14;
  final int lmsAccess14;
  final double nightActivityRatio;
  final int incomeCategory; // 0=low, 1=mid, 2=high
  final bool scholarshipTerminated;
  final int clubEngagement;
  final List<int> attendanceTrend14;
  final List<int> networkTrend14;

  Student({
    required this.name,
    required this.scholarId,
    required this.department,
    required this.gradYear,
    required this.attendancePercent,
    required this.avgMinutesNetwork14,
    required this.lmsAccess14,
    required this.nightActivityRatio,
    required this.incomeCategory,
    required this.scholarshipTerminated,
    required this.clubEngagement,
    required this.attendanceTrend14,
    required this.networkTrend14,
  });
}
