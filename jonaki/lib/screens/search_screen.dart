import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  // Sample data
  final List<Map<String, dynamic>> allStudents = List.generate(25, (index) {
    final riskScores = [95, 80, 60, 30];
    final riskTypes = [
      "Very high risk",
      "High risk",
      "Medium risk",
      "Elementary risk"
    ];
    final i = index % 4;
    return {
      "name": "Student ${index + 1}",
      "scholarId": "SID${1000 + index}",
      "riskScore": riskScores[i],
      "riskType": riskTypes[i],
    };
  });

  // Pagination
  int rowsPerPage = 10;
  int currentPage = 1;

  // Filters
  String selectedFilter = "no filter";
  final TextEditingController filterValueController = TextEditingController();
  final TextEditingController searchController = TextEditingController();
  final TextEditingController pageController = TextEditingController();

  List<Map<String, dynamic>> filteredStudents = [];

  @override
  void initState() {
    super.initState();
    filteredStudents = List.from(allStudents);
  }

  // Apply filter + search
  void applyFilters() {
    setState(() {
      filteredStudents = allStudents.where((student) {
        final searchText = searchController.text.toLowerCase();
        final filterValue = filterValueController.text.toLowerCase();

        // Search by name or scholar ID
        final matchesSearch = searchText.isEmpty ||
            student["name"].toLowerCase().contains(searchText) ||
            student["scholarId"].toLowerCase().contains(searchText);

        // Apply filter by dropdown
        bool matchesFilter = true;
        if (selectedFilter != "no filter" && filterValue.isNotEmpty) {
          matchesFilter = student.values.any(
              (value) => value.toString().toLowerCase().contains(filterValue));
        }

        return matchesSearch && matchesFilter;
      }).toList();

      currentPage = 1; // reset pagination
    });
  }

  // Risk type color
  Color getRiskColor(String riskType) {
    switch (riskType) {
      case "Very high risk":
        return Colors.red.shade900;
      case "High risk":
        return Colors.red;
      case "Medium risk":
        return Colors.orange;
      case "Elementary risk":
        return Colors.yellow.shade700;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final totalPages = (filteredStudents.length / rowsPerPage)
        .ceil()
        .clamp(1, double.infinity)
        .toInt();

    final startIndex = (currentPage - 1) * rowsPerPage;
    final endIndex = (startIndex + rowsPerPage < filteredStudents.length)
        ? startIndex + rowsPerPage
        : filteredStudents.length;

    final currentRows = filteredStudents.sublist(startIndex, endIndex);

    final themeColor = Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: AppBar(title: const Text("At-Risk Students")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // 🔍 Top portion: Search + Filter + Apply (Updated, compact & fancy)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Search field
                SizedBox(
                  height: 40,
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      hintText: "Search by name or scholar ID",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(width: 1),
                      ),
                      prefixIcon: const Icon(Icons.search, size: 20),
                      contentPadding: const EdgeInsets.symmetric(vertical: 0),
                      filled: true,
                      fillColor: Colors.grey.shade100,
                    ),
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
                const SizedBox(height: 10),

                // Filter dropdown + value input
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: DropdownButtonFormField<String>(
                        initialValue:
                            selectedFilter, // ✅ replaces deprecated 'value'
                        items: const [
                          DropdownMenuItem(
                              value: "no filter", child: Text("No filter")),
                          DropdownMenuItem(
                              value: "graduation year",
                              child: Text("Graduation Year")),
                          DropdownMenuItem(
                              value: "department", child: Text("Department")),
                          DropdownMenuItem(
                              value: "gender", child: Text("Gender")),
                        ],
                        onChanged: (val) =>
                            setState(() => selectedFilter = val!),
                        decoration: InputDecoration(
                          labelText: "Filter by",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide:
                                BorderSide(color: themeColor.withOpacity(0.7)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide:
                                BorderSide(color: themeColor.withOpacity(0.5)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide:
                                BorderSide(color: themeColor, width: 1.5),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 0),
                          filled: true,
                          fillColor: themeColor.withOpacity(
                              0.05), // very light themed background
                        ),
                        style: const TextStyle(fontSize: 14, color: Colors.black87),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      flex: 1,
                      child: SizedBox(
                        height: 40,
                        child: TextField(
                          controller: filterValueController,
                          decoration: InputDecoration(
                            hintText: "Enter filter value",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 0),
                            filled: true,
                            fillColor: Colors.grey.shade100,
                          ),
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Apply button (smaller, compact & fancy)
                Align(
                  alignment: Alignment.centerLeft,
                  child: SizedBox(
                    height: 32,
                    child: ElevatedButton.icon(
                      onPressed: applyFilters,
                      icon: const Icon(Icons.check, size: 16),
                      label: const Text(
                        "Apply",
                        style: TextStyle(fontSize: 13),
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                        elevation: 2,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // 📊 Table (2 columns, responsive + scrollable)
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Scrollbar(
                    thumbVisibility: true,
                    trackVisibility: true,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: ConstrainedBox(
                        constraints:
                            BoxConstraints(minWidth: constraints.maxWidth),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: DataTable(
                            columnSpacing: 30,
                            headingRowHeight: 50,
                            dataRowMinHeight: 50,
                            dataRowMaxHeight: 70,
                            columns: const [
                              DataColumn(label: Text("Student")),
                              DataColumn(label: Text("Risk Score")),
                            ],
                            rows: currentRows.map((student) {
                              return DataRow(
                                cells: [
                                  // Student column: name + scholarId
                                  DataCell(
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          student["name"],
                                          style: TextStyle(
                                            color: themeColor,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          student["scholarId"],
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Risk Score column: score + colored indicator
                                  DataCell(
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          student["riskScore"].toString(),
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(height: 4),
                                        Row(
                                          children: [
                                            Container(
                                              width: 12,
                                              height: 12,
                                              decoration: BoxDecoration(
                                                color: getRiskColor(
                                                    student["riskType"]),
                                                shape: BoxShape.circle,
                                              ),
                                            ),
                                            const SizedBox(width: 6),
                                            Text(
                                              student["riskType"],
                                              style: const TextStyle(
                                                fontSize: 12,
                                                color: Colors.black87,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 8),

            // ⬅️ Pagination controls
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_left),
                  onPressed: currentPage > 1
                      ? () => setState(() => currentPage--)
                      : null,
                ),
                Text("Page $currentPage of $totalPages"),
                IconButton(
                  icon: const Icon(Icons.arrow_right),
                  onPressed: currentPage < totalPages
                      ? () => setState(() => currentPage++)
                      : null,
                ),
              ],
            ),

            const SizedBox(height: 8),

            // ⌨️ Enter page number (compact & responsive)
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 80.0), // center input
              child: SizedBox(
                height: 36,
                child: TextField(
                  controller: pageController,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    hintText: "Enter Page no.",
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  style: const TextStyle(fontSize: 14),
                  onSubmitted: (value) {
                    final page = int.tryParse(value);
                    if (page != null && page >= 1 && page <= totalPages) {
                      setState(() => currentPage = page);
                    }
                    pageController.clear();
                  },
                ),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
