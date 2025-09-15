import 'package:flutter/material.dart';
import 'package:jonaki/screens/alert_screen.dart';
import '../theme/colors.dart';
import '../models/mock_dashboard.dart';

class HomeScreen extends StatelessWidget {
  final branches = MockDashboard.generateBranches();
  final indicators = MockDashboard.generateIndicators();

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kOffNavy,
        title: const Text(
          'Home Dashboard',
          style: TextStyle(color: Colors.white),
        ),
        elevation: 2,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // === TOP SUMMARY ===
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildKpiCard('Total Students', '1,240', Icons.people, kGold),
                _buildKpiCard('At-Risk Students', '96', Icons.warning_amber,
                    Colors.redAccent),
                _buildKpiCard('Pending Interventions', '42',
                    Icons.pending_actions, Colors.orange),
                _buildKpiCard('Successful Interventions', '128',
                    Icons.check_circle, Colors.green),
              ],
            ),

            const SizedBox(height: 24),

            // === BRANCH INDICATORS ===
            const Text("Branch-wise Indicators",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: branches.length,
              itemBuilder: (context, index) {
                final b = branches[index];
                return _buildBranchExpandable(b);
              },
            ),
            const SizedBox(height: 24),

            // === RISK INDICATORS ===
            const Text("Composite Risk Indicators",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: indicators.length,
              itemBuilder: (context, index) {
                final r = indicators[index];

                // rename "Self-Efficacy" to "Low Self-Efficacy Risk"
                final label = r.label == "Self-Efficacy"
                    ? "Low Self-Efficacy Risk"
                    : r.label;

                return _buildRiskTile(label, r);
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AlertScreen(),
            ),
          );
        },
        icon: const Icon(Icons.warning_amber_rounded),
        label: const Text('View Alerts'),
        backgroundColor: kPale, // or kPale if you prefer
      ),
    );
  }

  // === Widgets ===
  Widget _buildKpiCard(String title, String value, IconData icon, Color color) {
    return Card(
      color: kVeryLightGold,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 28, color: color),
            const SizedBox(height: 6),
            Text(value,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 2),
            Text(title,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12, color: Colors.black54)),
          ],
        ),
      ),
    );
  }

  Widget _buildBranchExpandable(BranchStats b) {
    return Card(
      color: kLightGold,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        title: Text(
          b.branch,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: kOffNavy,
          ),
        ),
        subtitle: Row(
          children: [
            Text("Students: ${b.students}",
                style: TextStyle(color: kRoughBrown, fontSize: 12)),
            const SizedBox(width: 12),
            Text("At-Risk: ${b.atRisk}",
                style: const TextStyle(color: Colors.red, fontSize: 12)),
          ],
        ),
        children: [
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Digital Overexposure: ${b.digitalOverexposure}%",
                    style: const TextStyle(fontSize: 13)),
                Text("Academic Stress: ${b.academicStress}%",
                    style: const TextStyle(fontSize: 13)),
                Text("Financial Stress: ${b.financialStress}%",
                    style: const TextStyle(fontSize: 13)),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.warning_amber,
                        size: 16, color: Colors.red),
                    const SizedBox(width: 4),
                    Text("${b.atRisk} flagged",
                        style:
                            const TextStyle(color: Colors.red, fontSize: 12)),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRiskTile(String label, RiskIndicator r) {
    Color color;
    switch (r.level) {
      case "Low":
        color = Colors.green;
        break;
      case "Medium":
        color = Colors.orange;
        break;
      default:
        color = Colors.red;
    }
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(Icons.assessment, color: color),
        title: Text(label, style: TextStyle(color: kOffNavy)),
        subtitle: Text("Level: ${r.level}",
            style: TextStyle(color: kRoughBrown, fontSize: 12)),
        trailing: Text("${r.value}%",
            style: TextStyle(fontWeight: FontWeight.bold, color: color)),
      ),
    );
  }
}
