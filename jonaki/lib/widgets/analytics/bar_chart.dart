import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../theme/colors.dart'; // Jonaki colors

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
    final barWidth = 20.0;

    // Darker colors for bars
    final barColors = [
      const Color(0xFFB8860B), // Dark Gold
      const Color(0xFF4B2E1A), // Dark RoughBrown
      const Color(0xFF020527), // Dark OffNavy
      const Color(0xFFB8860B),
      const Color(0xFF4B2E1A),
      const Color(0xFF020527),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        // Find the maximum width needed for legend boxes
        final textStyle = const TextStyle(
            color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14);
        double maxTextWidth = 0;
        final textPainter = TextPainter(
          textDirection: TextDirection.ltr,
        );
        for (var i = 0; i < keys.length; i++) {
          textPainter.text = TextSpan(text: "${i + 1}. ${keys[i]}", style: textStyle);
          textPainter.layout();
          if (textPainter.width > maxTextWidth) maxTextWidth = textPainter.width;
        }

        // Make the box width a bit larger than the largest text
        final boxWidth = maxTextWidth + 24; // padding 12 left+right

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: kPale,
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "Risk Distribution",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              // Bar chart
              SizedBox(
                height: 250,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(keys.length, (i) {
                      return SizedBox(
                        width: barWidth + 16,
                        child: BarChart(
                          BarChartData(
                            maxY: maxY,
                            gridData: const FlGridData(show: false),
                            borderData: FlBorderData(show: false),
                            titlesData: FlTitlesData(
                              leftTitles: const AxisTitles(
                                  sideTitles: SideTitles(showTitles: false)),
                              topTitles: const AxisTitles(
                                  sideTitles: SideTitles(showTitles: false)),
                              rightTitles: const AxisTitles(
                                  sideTitles: SideTitles(showTitles: false)),
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
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold),
                                    );
                                  },
                                ),
                              ),
                            ),
                            barGroups: [
                              BarChartGroupData(
                                x: i,
                                barRods: [
                                  BarChartRodData(
                                    toY: values[i].toDouble(),
                                    color: barColors[i % barColors.length],
                                    width: barWidth,
                                    borderRadius: BorderRadius.zero,
                                  )
                                ],
                              )
                            ],
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
                      );
                    }),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Legend: 2-column grid with equal-width boxes
              Wrap(
                spacing: 12,
                runSpacing: 8,
                alignment: WrapAlignment.center,
                children: List.generate(keys.length, (i) {
                  return Container(
                    width: boxWidth,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                    decoration: BoxDecoration(
                      color: barColors[i % barColors.length],
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Center(
                      child: Text(
                        "${i + 1}. ${keys[i]}",
                        textAlign: TextAlign.center,
                        style: textStyle,
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
        );
      },
    );
  }
}
