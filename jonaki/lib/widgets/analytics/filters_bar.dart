import 'package:flutter/material.dart';

class FiltersBar extends StatelessWidget {
  final void Function(String filter) onSelected;

  const FiltersBar({super.key, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      children: [
        FilterChip(label: const Text("Attendance"), onSelected: (_) => onSelected("attendance")),
        FilterChip(label: const Text("Network"), onSelected: (_) => onSelected("network")),
        FilterChip(label: const Text("LMS"), onSelected: (_) => onSelected("lms")),
        FilterChip(label: const Text("Clubs"), onSelected: (_) => onSelected("club")),
        FilterChip(label: const Text("Scholarship"), onSelected: (_) => onSelected("scholarship")),
      ],
    );
  }
}
