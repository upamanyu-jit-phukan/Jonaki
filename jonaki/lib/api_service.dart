import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  static const String apiUrl = 'https://jonakifinal-seof.onrender.com/predict';

  static Future<Map<String, dynamic>> getPrediction(Map<String, dynamic> studentData) async {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(studentData),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to fetch prediction');
    }
  }
}
