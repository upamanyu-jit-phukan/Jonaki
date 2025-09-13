import 'package:flutter/material.dart';
import 'percentage_ring.dart';

class RiskDetailCard extends StatelessWidget {
  final String title;
  final int studentCount;
  final String formulaText;

  const RiskDetailCard({
    super.key,
    required this.title,
    required this.studentCount,
    required this.formulaText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Row(
            children: [
              PercentageRing(percentage: studentCount / 100, color: Colors.blue),
              const SizedBox(width: 16),
              Text("$studentCount students flagged", style: const TextStyle(fontSize: 16)),
            ],
          ),
          const SizedBox(height: 12),
          Text("Formula:", style: TextStyle(color: Colors.grey.shade700, fontWeight: FontWeight.w500)),
          const SizedBox(height: 6),
          Text(formulaText, style: const TextStyle(fontSize: 14, fontStyle: FontStyle.italic)),
        ],
      ),
    );
  }
}
