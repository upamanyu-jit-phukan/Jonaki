import 'package:flutter/material.dart';

class AlertsList extends StatelessWidget {
  const AlertsList({super.key});

  @override
  Widget build(BuildContext context) {
    final alerts = [
      "⚠️ 12 students absent 15+ days",
      "⚠️ 8 students failed recent minor test",
      "⚠️ 5 fee defaulters (2 consecutive terms)",
    ];

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 3,
      child: ListView.builder(
        itemCount: alerts.length,
        itemBuilder: (_, i) => ListTile(
          leading: const Icon(Icons.warning_amber, color: Colors.red),
          title: Text(alerts[i]),
        ),
      ),
    );
  }
}
