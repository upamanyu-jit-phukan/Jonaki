import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class BarChartWidget extends StatelessWidget {
  final Map<String, int> data;
  const BarChartWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final keys = data.keys.toList();
    final values = data.values.toList();
    final maxValue =
        values.isNotEmpty ? values.reduce((a, b) => a > b ? a : b) : 1;
    final maxY = (maxValue * 1.3).toDouble();
    final barColor = Colors.deepPurple.shade400;

    // Shrink width per bar to fit more on screen
    final barWidth = 20.0;

    return Container(
      width: double.infinity, // full-width card
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Risk Distribution",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

          // --- Bar chart (scrollable & shrunk) ---
          SizedBox(
            height: 250,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Center(
                child: SizedBox(
                  width: (keys.length * (barWidth + 16))
                      .clamp(200.0, double.infinity)
                      .toDouble(),
                  child: BarChart(
                    BarChartData(
                      maxY: maxY,
                      gridData: const FlGridData(show: false),
                      borderData: FlBorderData(show: false),
                      titlesData: FlTitlesData(
                        leftTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 24,
                            getTitlesWidget: (value, meta) {
                              final idx = value.toInt();
                              if (idx < 0 || idx >= keys.length)
                                return const SizedBox.shrink();
                              return Text(
                                '${idx + 1}',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.bold),
                              );
                            },
                          ),
                        ),
                      ),
                      barGroups: List.generate(keys.length, (i) {
                        return BarChartGroupData(
                          x: i,
                          barRods: [
                            BarChartRodData(
                              toY: values[i].toDouble(),
                              color: barColor,
                              width: barWidth,
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ],
                        );
                      }),
                      barTouchData: BarTouchData(
                        enabled: true,
                        touchTooltipData: BarTouchTooltipData(
                          getTooltipItem: (group, _, rod, __) {
                            return BarTooltipItem(
                              "${rod.toY.toInt()} students",
                              const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // --- Category legend (2 per row) ---
          Wrap(
            spacing: 16,
            runSpacing: 8,
            children: List.generate(keys.length, (i) {
              return SizedBox(
                width: (MediaQuery.of(context).size.width - 48) / 2,
                child: Text(
                  "${i + 1}. ${keys[i]}",
                  style: const TextStyle(fontSize: 14),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
