import 'package:flutter/material.dart';

class DeptHeatmap extends StatelessWidget {
  const DeptHeatmap({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 3,
      child: const Center(
        child: Text("Dept-wise Heatmap Placeholder"),
      ),
    );
  }
}
