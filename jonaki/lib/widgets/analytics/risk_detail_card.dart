// lib/widgets/analytics/risk_detail_card.dart
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

/// RiskDetailCard
/// - Renders different visualizations depending on `title`
/// - Expects `title` to be one of the category keys used in the analytics screen:
///   "Dropout Risk", "Late-Night Activity", "Low Self-Efficacy", "Mental Health",
///   "Social Isolation", "Financial Stress", "Academic Stress"
///
/// NOTE: This widget uses deterministic mock data derived from `studentCount`
/// so visuals are reproducible. Replace the mock generators with your real
/// time-series / factor data when available.

class RiskDetailCard extends StatefulWidget {
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
  State<RiskDetailCard> createState() => _RiskDetailCardState();
}

class _RiskDetailCardState extends State<RiskDetailCard> {
  final ScrollController _hCtrl = ScrollController();

  // show up to this many months at once by default if there's enough width
  static const int defaultMonthsVisible = 10;

  // helper: generate last N month labels (e.g., "2024-10", "2024-11", ...)
  List<String> _lastNMonths(int n) {
    final now = DateTime.now();
    final list = <String>[];
    for (int i = n - 1; i >= 0; i--) {
      final dt = DateTime(now.year, now.month - i);
      list.add("${dt.year}-${dt.month.toString().padLeft(2, '0')}");
    }
    return list;
  }

  // deterministic "mock" monthly series for a metric using seed from title
  List<int> _mockMonthlySeries(int months, int base) {
    final seed = widget.title.hashCode ^ base;
    final rnd = Random(seed);
    // create smoothly changing values using random walk
    double val = max(0, base.toDouble());
    final series = <int>[];
    for (int i = 0; i < months; i++) {
      final delta = (rnd.nextDouble() - 0.45) * base * 0.12; // small moves
      val = max(0, val + delta);
      series.add(val.round());
    }
    return series;
  }

  // generate factor breakdowns for pie or grouped bars
  Map<String, int> _mockFactors(String key, int count, int factorsCount) {
    final seed = key.hashCode ^ count;
    final rnd = Random(seed);
    final Map<String, int> out = {};
    // Generate factors names and values that sum up ~count (but not strictly)
    int remaining = max(0, count);
    for (int i = 0; i < factorsCount; i++) {
      final name = switch (key) {
        'Low Self-Efficacy' => 'Factor ${i + 1} (E${i + 1})',
        'Mental Health' => 'Factor ${i + 1} (M${i + 1})',
        'Financial Stress' => 'Factor ${i + 1} (F${i + 1})',
        'Academic Stress' => 'Factor ${i + 1} (A${i + 1})',
        _ => 'Factor ${i + 1}',
      };
      // mix of random and proportional
      final val = (remaining > 0)
          ? (rnd.nextInt(max(1, (remaining ~/ (factorsCount - i)))) +
              (count ~/ (factorsCount + 1)))
          : rnd.nextInt(max(1, count ~/ 4));
      out[name] = val;
      remaining = max(0, remaining - val);
    }
    return out;
  }

  // For social isolation double bars: produce pairs (aboveThreshold, critical)
  List<Map<String, int>> _mockSocialBars(int count, int factorsCount) {
    final seed = widget.title.hashCode ^ count;
    final rnd = Random(seed);
    final List<Map<String, int>> list = [];
    for (int i = 0; i < factorsCount; i++) {
      final base = max(0, (count * (0.6 - 0.08 * i)).round() + rnd.nextInt(8));
      final critical = max(0, (base * (0.25 + rnd.nextDouble() * 0.5)).round());
      final above = max(0, base - critical);
      list.add({'above': above, 'critical': critical});
    }
    return list;
  }

  // jump to latest months (scroll to end) helper
  void _jumpToLatest() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_hCtrl.hasClients) {
        _hCtrl.animateTo(_hCtrl.position.maxScrollExtent,
            duration: const Duration(milliseconds: 500), curve: Curves.easeOut);
      }
    });
  }

  @override
  void dispose() {
    _hCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.title;
    final cnt = widget.studentCount;
    final formula = widget.formulaText;

    // card container
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // header row
          Row(
            children: [
              Expanded(
                  child: Text(title,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold))),
              Text("$cnt flagged",
                  style: TextStyle(color: Colors.grey.shade700)),
              const SizedBox(width: 12),
              ElevatedButton.icon(
                onPressed: _jumpToLatest,
                icon: const Icon(Icons.update, size: 16),
                label: const Text("Latest", style: TextStyle(fontSize: 12)),
                style:
                    ElevatedButton.styleFrom(minimumSize: const Size(64, 32)),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // choose visualization by title
          if (title == 'Dropout Risk' || title == 'Late-Night Activity') ...[
            // Line chart area (scrollable horizontally)
            _buildScrollableLineChart(context, title, cnt),
            const SizedBox(height: 12),
            Text("Formula: $formula",
                style: TextStyle(color: Colors.grey.shade700)),
          ] else if (title == 'Low Self-Efficacy' ||
              title == 'Mental Health' ||
              title == 'Financial Stress' ||
              title == 'Academic Stress') ...[
            // Pie chart area for factor breakdown
            _buildPieChartArea(title, cnt),
            const SizedBox(height: 12),
            Text("Formula: $formula",
                style: TextStyle(color: Colors.grey.shade700)),
          ] else if (title == 'Social Isolation') ...[
            // Double-bar grouped chart for social factors
            _buildSocialGroupedBar(title, cnt),
            const SizedBox(height: 12),
            Text("Formula: $formula",
                style: TextStyle(color: Colors.grey.shade700)),
          ] else ...[
            // fallback
            Text("No visualization available for this category."),
            const SizedBox(height: 8),
            Text("Formula: $formula",
                style: TextStyle(color: Colors.grey.shade700)),
          ],
        ],
      ),
    );
  }

  // ---------- Line chart builder ----------
  Widget _buildScrollableLineChart(
      BuildContext context, String key, int count) {
    // generate 18 months of data (you'll see last N, default visible = 10)
    final monthsTotal = 18;
    final months = _lastNMonths(monthsTotal);
    final series = _mockMonthlySeries(monthsTotal, count);
    final maxY = (series.isEmpty ? 1 : series.reduce(max)) * 1.25;

    // width per month; try to fit defaultMonthsVisible in wide screens else show smaller
    final perMonthWidth = 76.0; // smaller to reduce overflow
    final chartWidth = (monthsTotal * perMonthWidth).toDouble();

    final spots = List.generate(
        monthsTotal, (i) => FlSpot(i.toDouble(), series[i].toDouble()));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 220,
          child: SingleChildScrollView(
            controller: _hCtrl,
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: chartWidth,
              child: LineChart(
                LineChartData(
                  minX: 0,
                  maxX: (monthsTotal - 1).toDouble(),
                  minY: 0,
                  maxY: maxY,
                  gridData: const FlGridData(show: false),
                  titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 40,
                              getTitlesWidget: (v, _) {
                                return Text(v.toInt().toString(),
                                    style: const TextStyle(fontSize: 11));
                              })),
                      bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 36,
                              getTitlesWidget: (v, _) {
                                final idx = v.toInt();
                                if (idx < 0 || idx >= months.length)
                                  return const SizedBox.shrink();
                                // show only a subset of month labels to avoid clutter
                                if (months.length > 12) {
                                  // pick every 2nd label when many months
                                  if (idx % 2 != 0)
                                    return const SizedBox.shrink();
                                }
                                return Text(months[idx],
                                    style: const TextStyle(fontSize: 11));
                              }))),
                  lineBarsData: [
                    LineChartBarData(
                      spots: spots,
                      isCurved: true,
                      color: Colors.deepPurple.shade400,
                      barWidth: 3,
                      dotData: FlDotData(
                        show: true,
                        getDotPainter: (spot, percent, barData, index) =>
                            FlDotCirclePainter(
                          radius: 4,
                          color: Colors.deepPurple.shade400,
                          strokeWidth: 2,
                          strokeColor: Colors.white,
                        ),
                      ),
                      belowBarData: BarAreaData(
                        show: true,
                        color: Colors.deepPurple.shade200.withValues(alpha: 50),
                        // 50 ~ 20% opacity (0–255)
                      ),
                    ),
                  ],
                  lineTouchData: LineTouchData(
                    touchTooltipData: LineTouchTooltipData(
                      tooltipPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      tooltipMargin: 8,
                      getTooltipColor: (touchedSpot) => Colors.black87,
                      getTooltipItems: (touchedSpots) {
                        return touchedSpots.map((t) {
                          final v = t.y.toInt();
                          final m = months[t.x.toInt()];
                          return LineTooltipItem(
                            "$m\n$v students",
                            const TextStyle(color: Colors.white),
                          );
                        }).toList();
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Row(children: [
          Text("Showing last ${months.length} months",
              style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
          const Spacer(),
          TextButton(
            onPressed: _jumpToLatest,
            child: const Text("Go to latest"),
          ),
        ]),
      ],
    );
  }

  // ---------- Pie chart area ----------
  Widget _buildPieChartArea(String key, int count) {
    final factorsCount =
        4 + (key == 'Low Self-Efficacy' ? 1 : 0); // 4-5 factors
    final factors = _mockFactors(key, count, factorsCount);
    final total = factors.values
        .fold<int>(0, (a, b) => a + b)
        .clamp(1, double.maxFinite.toInt());

    final colors = [
      Colors.red.shade600,
      Colors.orange.shade600,
      Colors.blue.shade600,
      Colors.green.shade600,
      Colors.purple.shade600
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 200,
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: PieChart(
                  PieChartData(
                    sections: List.generate(factors.length, (i) {
                      final vals = factors.entries.toList();
                      final label = vals[i].key;
                      final value = vals[i].value.toDouble();
                      final percent = total == 0 ? 0.0 : (value / total) * 100;
                      return PieChartSectionData(
                        value: value,
                        color: colors[i % colors.length],
                        title: "${percent.toStringAsFixed(0)}%",
                        radius: 48,
                        titleStyle: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              color: Colors.black.withOpacity(0.6),
                              blurRadius: 3,
                            ),
                          ],
                        ),
                      );
                    }),
                    sectionsSpace: 2,
                    centerSpaceRadius: 24,
                    pieTouchData: PieTouchData(enabled: true),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 1,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: factors.entries.map((e) {
                      final idx = factors.keys.toList().indexOf(e.key);
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Row(
                          children: [
                            Container(
                                width: 12,
                                height: 12,
                                color: colors[idx % colors.length]),
                            const SizedBox(width: 8),
                            Expanded(
                                child: Text(e.key,
                                    style: const TextStyle(fontSize: 14))),
                            const SizedBox(width: 8),
                            Text("${e.value}",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  // ---------- Social grouped bar chart ----------
  Widget _buildSocialGroupedBar(String key, int count) {
    final factorsCount = 5;
    final bars = _mockSocialBars(count, factorsCount);
    final labels = List.generate(factorsCount, (i) => "F${i + 1}");

    final maxVal =
        bars.expand((m) => m.values).fold<int>(0, (a, b) => a > b ? a : b);
    final maxY = max(1, (maxVal * 1.25).round());

    final groupWidth = 56.0;
    final totalWidth = (groupWidth * factorsCount).toDouble();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 260,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: totalWidth,
              child: BarChart(
                BarChartData(
                  maxY: maxY.toDouble(),
                  gridData: const FlGridData(show: false),
                  borderData: FlBorderData(show: false),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 40,
                            getTitlesWidget: (v, _) =>
                                Text(v.toInt().toString()))),
                    bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 36,
                            getTitlesWidget: (v, _) {
                              final idx = v.toInt();
                              if (idx < 0 || idx >= labels.length)
                                return const SizedBox.shrink();
                              return Text("${idx + 1}",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold));
                            })),
                  ),
                  barGroups: List.generate(factorsCount, (i) {
                    final above = bars[i]['above']!.toDouble();
                    final crit = bars[i]['critical']!.toDouble();
                    return BarChartGroupData(
                      x: i,
                      barsSpace: 0, // <- rods inside group touch
                      barRods: [
                        BarChartRodData(
                          toY: above,
                          width: 12,
                          color: Colors.blue.shade300,
                          borderRadius:
                              BorderRadius.zero, // no curve to keep flush
                        ),
                        BarChartRodData(
                          toY: crit,
                          width: 12,
                          color: Colors.blue.shade800,
                          borderRadius: BorderRadius.zero,
                        ),
                      ],
                      // add spacing between groups
                      groupVertically: false,
                    );
                  }),
                ),
              ),
            ),
          ),
        ),

        const SizedBox(height: 12),

        // legend: 2-per-row list mapping numbers to factor descriptions
        Wrap(
          spacing: 12,
          runSpacing: 8,
          children: List.generate(factorsCount, (i) {
            return SizedBox(
              width: (MediaQuery.of(context).size.width - 48) / 2,
              child: Row(
                children: [
                  Text("${i + 1}. ",
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  Expanded(
                      child: Text(
                          "Factor ${i + 1} — (e.g., club involvement, LMS access, peer interactions)")),
                ],
              ),
            );
          }),
        ),
      ],
    );
  }
}
