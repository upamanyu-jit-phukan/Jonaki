import 'package:flutter/material.dart';
import 'package:jonaki/theme/colors.dart';

class AlertScreen extends StatefulWidget {
  const AlertScreen({super.key});

  @override
  _AlertScreenState createState() => _AlertScreenState();
}

class _AlertScreenState extends State<AlertScreen> {
  final List<Map<String, dynamic>> alerts = [
    {
      "name": "Priya Sharma",
      "id": "SCH123",
      "category": "Attendance",
      "risk": "Critical",
      "summary": "Attendance dropped to 45% in last 2 weeks",
      "timestamp": "2h ago",
      "context": "Priya’s test scores dropped by 20% + attendance down 30%.",
    },
    {
      "name": "Amit Singh",
      "id": "SCH126",
      "category": "Finance",
      "risk": "Critical",
      "summary": "Fee overdue by 30 days",
      "timestamp": "5h ago",
      "context": "Amit’s fee has not been cleared despite reminders.",
    },
    {
      "name": "Riya Das",
      "id": "SCH127",
      "category": "Academic",
      "risk": "Critical",
      "summary": "Test scores fell by 25% in last 2 exams",
      "timestamp": "1d ago",
      "context": "Riya has consistent grade decline in core subjects.",
    },
  ];

  // Map risk levels to Jonaki theme colors
  Color _riskColor(String risk) {
    switch (risk) {
      case "Critical":
        return kGold;
      case "High":
        return kRoughBrown;
      case "Medium":
        return kOffNavy;
      default:
        return Colors.grey;
    }
  }

  // Map category background colors (optional, adjust as needed)
  Color _categoryBgColor(String category) {
    switch (category) {
      case "Attendance":
        return kOffNavy.withOpacity(0.15);
      case "Finance":
        return kGold.withOpacity(0.15);
      case "Academic":
        return kRoughBrown.withOpacity(0.15);
      default:
        return Colors.grey.withOpacity(0.1);
    }
  }

  // Map category text colors
  Color _categoryTextColor(String category) {
    switch (category) {
      case "Attendance":
        return kOffNavy;
      case "Finance":
        return kGold;
      case "Academic":
        return kRoughBrown;
      default:
        return Colors.grey.shade800;
    }
  }

  @override
  Widget build(BuildContext context) {
    final criticalAlerts =
        alerts.where((alert) => alert["risk"] == "Critical").toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Critical Alerts",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: kOffNavy,
      ),
      body: criticalAlerts.isEmpty
          ? const Center(
              child: Text(
                "🎉 No critical alerts",
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          : ListView.builder(
              itemCount: criticalAlerts.length,
              itemBuilder: (context, index) {
                final alert = criticalAlerts[index];
                return Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: ExpansionTile(
                    leading: CircleAvatar(
                      backgroundColor: _riskColor(alert["risk"]),
                      child: Text(alert["name"][0],
                          style: const TextStyle(color: Colors.white)),
                    ),
                    title: Text(
                      "${alert["name"]} (${alert["id"]})",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: kOffNavy,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(alert["summary"]),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            // Risk badge
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: _riskColor(alert["risk"]).withOpacity(0.2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                alert["risk"],
                                style: TextStyle(
                                  color: _riskColor(alert["risk"]),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            // Category tag
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: _categoryBgColor(alert["category"]),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                alert["category"],
                                style: TextStyle(
                                  color: _categoryTextColor(alert["category"]),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            const Spacer(),
                            Text(
                              alert["timestamp"],
                              style: const TextStyle(
                                  fontSize: 12, color: Colors.grey),
                            ),
                          ],
                        )
                      ],
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("📌 Context:",
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            Text(alert["context"]),
                            const SizedBox(height: 10),
                            const Text("📈 Trend (placeholder graph here)",
                                style: TextStyle(color: Colors.grey)),
                            const SizedBox(height: 10),
                            const Text("💡 Suggested interventions:",
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            Wrap(
                              spacing: 8,
                              children: [
                                OutlinedButton(
                                    onPressed: () {},
                                    child: const Text("Schedule meeting")),
                                OutlinedButton(
                                    onPressed: () {},
                                    child: const Text("Send message")),
                                OutlinedButton(
                                    onPressed: () {},
                                    child: const Text("Flag to counselor")),
                              ],
                            ),
                            const Divider(),
                            Row(
                              children: [
                                TextButton.icon(
                                  icon: const Icon(Icons.check_circle,
                                      color: kGold),
                                  label: const Text("Resolve"),
                                  onPressed: () {},
                                ),
                                TextButton.icon(
                                  icon: const Icon(Icons.snooze,
                                      color: kRoughBrown),
                                  label: const Text("Snooze"),
                                  onPressed: () {},
                                ),
                              ],
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
    );
  }
}
