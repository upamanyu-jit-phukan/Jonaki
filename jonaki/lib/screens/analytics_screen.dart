import 'package:flutter/material.dart';
import 'package:jonaki/utils/student_dummy.dart';
import '../../models/student.dart';
import '../../utils/analytics_utils.dart';
import '../../widgets/analytics/filters_bar.dart';
import '../../widgets/analytics/metric_card.dart';
import '../../widgets/analytics/metric_detail.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  String selectedFilter = "attendance";

  // 🔹 Dummy student data
  final List<Student> students = StudentsDummy.generate(count: 25);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Analytics")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            FiltersBar(onSelected: (filter) {
              setState(() => selectedFilter = filter);
            }),
            const SizedBox(height: 16),

            // Example metric cards
            MetricCard(
              title: "Attendance",
              value: "${students[0].attendancePercent}%",
              subtitle: "Avg across batch",
              icon: Icons.school,
              color: Colors.red,
              onTap: () {
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    content: MetricDetail(
                      title: "Attendance Trend",
                      trend: students[0]
                          .attendanceTrend14
                          .map((e) => e.toDouble())
                          .toList(),
                      avg: mean(students.map((s) => s.attendancePercent.toDouble()).toList()),
                      median: median(students.map((s) => s.attendancePercent.toDouble()).toList()),
                      sd: stddev(students.map((s) => s.attendancePercent.toDouble()).toList()),
                    ),
                  ),
                );
              },
            ),

            MetricCard(
              title: "Network Usage",
              value: "${students[0].avgMinutesNetwork14} mins",
              subtitle: "Past 14 days",
              icon: Icons.wifi,
              color: Colors.blue,
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
