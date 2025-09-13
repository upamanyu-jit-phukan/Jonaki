import 'package:flutter/material.dart';
import 'sparkline.dart';

class MetricDetail extends StatelessWidget {
  final String title;
  final List<double> trend;
  final double avg;
  final double median;
  final double sd;

  const MetricDetail({
    super.key,
    required this.title,
    required this.trend,
    required this.avg,
    required this.median,
    required this.sd,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleLarge),
            SizedBox(
              height: 120,
              child: CustomPaint(
                painter: SparklinePainter(points: trend, color: Colors.blue),
              ),
            ),
            const SizedBox(height: 12),
            Text("Average: ${avg.toStringAsFixed(2)}"),
            Text("Median: ${median.toStringAsFixed(2)}"),
            Text("Std Dev: ${sd.toStringAsFixed(2)}"),
          ],
        ),
      ),
    );
  }
}
