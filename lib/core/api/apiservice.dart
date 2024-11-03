import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = 'https://anteshnatsh.tryasp.net';

  // Method to get all names
  Future<List<String>> getAllNames() async {
    final response = await http.get(Uri.parse('$baseUrl/api/Graph/AllNames'));

    if (response.statusCode == 200) {
      // Decode response as List of Strings
      return List<String>.from(json.decode(response.body));
    } else {
      throw Exception('Failed to load names');
    }
  }

  // Method to get patient data by name
  Future<List<PatientDto>> getPatientDataByName(String name) async {
    final response = await http.get(Uri.parse('$baseUrl/api/Graph/$name'));

    if (response.statusCode == 200) {
      // Decode response as List of PatientDto objects
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => PatientDto.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load patient data');
    }
  }
}

// Model class for PatientDto
class PatientDto {
  final double sugarPercentage;
  final String time;
  final String date;

  PatientDto({
    required this.sugarPercentage,
    required this.time,
    required this.date,
  });

  // Factory constructor to create a PatientDto from JSON
  factory PatientDto.fromJson(Map<String, dynamic> json) {
    return PatientDto(
      sugarPercentage: json['sugarPercentage'],
      time: json['time'],
      date: json['date'],
    );
  }
}
