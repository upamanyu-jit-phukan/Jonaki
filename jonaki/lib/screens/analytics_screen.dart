import 'package:flutter/material.dart';
import 'package:jonaki/models/student.dart';
import 'package:jonaki/utils/student_dummy.dart';
import 'package:jonaki/utils/risk_formulas.dart';
import 'package:jonaki/widgets/analytics/info_card.dart';
import 'package:jonaki/widgets/analytics/bar_chart.dart';
import 'package:jonaki/widgets/analytics/risk_detail_card.dart';

class AnalyticsScreenFull extends StatelessWidget {
  const AnalyticsScreenFull({super.key});

  @override
  Widget build(BuildContext context) {
    final students = StudentsDummy.generate(count: 120);

    // --- Aggregates ---
    final atRisk =
        students.where((s) => RiskFormulas.dropoutRisk(s) > 0.6).length;
    final pending = 24; // placeholder, from interventions db
    final successful = 12; // placeholder
    final changeInRisk = -5; // placeholder from last month

    // --- Risk categories counts ---
    final Map<String, int> riskCounts = {
      "Dropout Risk":
          students.where((s) => RiskFormulas.dropoutRisk(s) > 0.6).length,
      "Late-Night Activity":
          students.where((s) => RiskFormulas.lateNightRisk(s) > 0.6).length,
      "Low Self-Efficacy":
          students.where((s) => RiskFormulas.selfEfficacyRisk(s) > 0.6).length,
      "Mental Health":
          students.where((s) => RiskFormulas.mentalHealthRisk(s) > 0.6).length,
      "Social Isolation": students
          .where((s) => RiskFormulas.socialIsolationRisk(s) > 0.6)
          .length,
      "Financial Stress": students
          .where((s) => RiskFormulas.financialStressRisk(s) > 0.6)
          .length,
      "Academic Stress": students
          .where((s) => RiskFormulas.academicStressRisk(s) > 0.6)
          .length,
    };

    return Scaffold(
      appBar: AppBar(title: const Text("Analytics Dashboard")),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // --- Quadrant Cards ---
                // --- Quadrant Cards ---
                GridView.count(
                  shrinkWrap: true,
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  physics:
                      const NeverScrollableScrollPhysics(), // avoids nested scroll clash
                  childAspectRatio: 1.2, // adjust height/width ratio
                  children: [
                    InfoCard(
                      title: "At-Risk Students",
                      value: atRisk.toString(),
                      color: Colors.red,
                      icon: Icons.warning_amber_rounded,
                    ),
                    InfoCard(
                      title: "Pending Interventions",
                      value: pending.toString(),
                      color: Colors.orange,
                      icon: Icons.pending_actions,
                    ),
                    InfoCard(
                      title: "Successful Interventions",
                      value: successful.toString(),
                      color: Colors.green,
                      icon: Icons.check_circle_rounded,
                    ),
                    InfoCard(
                      title: "Trend vs Last Month",
                      value: "${changeInRisk.abs()}%",
                      color: changeInRisk >= 0 ? Colors.red : Colors.green,
                      icon: changeInRisk >= 0
                          ? Icons.trending_up_rounded
                          : Icons.trending_down_rounded,
                      subtitle: changeInRisk >= 0
                          ? "↑ More students at risk"
                          : "↓ Fewer students at risk",
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // --- Risk Category Bar Chart ---
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [
                      BoxShadow(color: Colors.black12, blurRadius: 4)
                    ],
                  ),
                  child: BarChartWidget(data: riskCounts),
                ),
                const SizedBox(height: 24),

                // --- Detailed Circular Dashboards ---
                Column(
                  children: riskCounts.entries.map((entry) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: RiskDetailCard(
                        title: entry.key,
                        studentCount: entry.value,
                        formulaText: RiskFormulas.getFormulaText(entry.key),
                      ),
                    );
                  }).toList(),
                ),

                const SizedBox(height: 32),
                Text(
                  "Last updated: 14 Sept 2025, 8:42 PM",
                  style: TextStyle(
                      color: Colors.grey.shade600, fontStyle: FontStyle.italic),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
