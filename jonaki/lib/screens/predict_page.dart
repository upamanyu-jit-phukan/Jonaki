import 'package:flutter/material.dart';
import '../api_service.dart';

class PredictPage extends StatefulWidget {
  const PredictPage({super.key});

  @override
  State<PredictPage> createState() => _PredictPageState();
}

class _PredictPageState extends State<PredictPage> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> studentData = {
    "Attendance": 0,
    "Current_GPA": 0,
    "Previous_GPA": 0,
    "GPA_Diff": 0,
    "NonProductive_Hrs": 0,
    "Productive_Hrs": 0,
    "Club_Score": 0,
    "Internship_Status": 0,
    "Family_Income": "<1 LPA",
    "Sentiment_Score": 0,
  };

  String result = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Predict Dropout")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Attendance'),
                      keyboardType: TextInputType.number,
                      onSaved: (value) => studentData["Attendance"] = double.tryParse(value!) ?? 0,
                    ),
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Current GPA'),
                      keyboardType: TextInputType.number,
                      onSaved: (value) => studentData["Current_GPA"] = double.tryParse(value!) ?? 0,
                    ),
                    // Add more fields as needed...
                  ],
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                _formKey.currentState?.save();
                try {
                  final response = await ApiService.getPrediction(studentData);
                  setState(() {
                    result =
                        'Dropout Probability: ${response['dropout_probability']}%\nSuggestions: ${response['suggestions'].join(', ')}';
                  });
                } catch (e) {
                  setState(() {
                    result = 'Error: $e';
                  });
                }
              },
              child: const Text("Predict"),
            ),
            const SizedBox(height: 20),
            Text(result),
          ],
        ),
      ),
    );
  }
}
