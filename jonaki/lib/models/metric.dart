enum MetricKey { attendance, network, lms, night, club, scholarship }

class MetricStats {
  final double avg;
  final double median;
  final double sd;

  MetricStats({
    required this.avg,
    required this.median,
    required this.sd,
  });
}
