import 'package:flutter/material.dart';

class AlertScreen extends StatefulWidget {
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

  Color _riskColor(String risk) {
    return Colors.red.shade700;
  }

  @override
  Widget build(BuildContext context) {
    final criticalAlerts =
        alerts.where((alert) => alert["risk"] == "Critical").toList();

    return Scaffold(
      appBar: AppBar(
        title: Text("Critical Alerts"),
        backgroundColor: Colors.indigo,
      ),
      body: criticalAlerts.isEmpty
          ? Center(
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
                  margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: ExpansionTile(
                    leading: CircleAvatar(
                      backgroundColor: _riskColor(alert["risk"]),
                      child: Text(alert["name"][0],
                          style: TextStyle(color: Colors.white)),
                    ),
                    title: Text(
                      "${alert["name"]} (${alert["id"]})",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.indigo,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(alert["summary"]),
                        SizedBox(height: 4),
                        Row(
                          children: [
                            // Risk badge
                            Container(
                              padding: EdgeInsets.symmetric(
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
                            SizedBox(width: 8),
                            // Category tag
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.blue.shade50,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                alert["category"],
                                style: TextStyle(
                                  color: Colors.blue.shade700,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Spacer(),
                            Text(
                              alert["timestamp"],
                              style: TextStyle(fontSize: 12, color: Colors.grey),
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
                            Text("📌 Context:",
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            Text(alert["context"]),
                            SizedBox(height: 10),
                            Text("📈 Trend (placeholder graph here)",
                                style: TextStyle(color: Colors.grey)),
                            SizedBox(height: 10),
                            Text("💡 Suggested interventions:",
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            Wrap(
                              spacing: 8,
                              children: [
                                OutlinedButton(
                                    onPressed: () {},
                                    child: Text("Schedule meeting")),
                                OutlinedButton(
                                    onPressed: () {},
                                    child: Text("Send message")),
                                OutlinedButton(
                                    onPressed: () {},
                                    child: Text("Flag to counselor")),
                              ],
                            ),
                            Divider(),
                            // Batch actions (only resolve + snooze)
                            Row(
                              children: [
                                TextButton.icon(
                                  icon: Icon(Icons.check_circle,
                                      color: Colors.green),
                                  label: Text("Resolve"),
                                  onPressed: () {},
                                ),
                                TextButton.icon(
                                  icon: Icon(Icons.snooze,
                                      color: Colors.orange),
                                  label: Text("Snooze"),
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
