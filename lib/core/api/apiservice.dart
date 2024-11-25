/*
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:kikira/core/classes/getallcritical.dart';
import 'package:kikira/core/classes/patientdto.dart';
import 'package:kikira/core/classes/patientdtoname.dart';

class ApiService {
  final String baseUrl = 'https://anteshnatsh.tryasp.net';

  // Method to get all names
  Future<List<PatientDtoName>> getAllNames() async {
    final response = await http.get(Uri.parse('$baseUrl/api/Graph/AllNames'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      print('All Names Response: $data');
      return data.map((json) => PatientDtoName.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load names');
    }
  }

  // Method to get all critical data
  Future<List<GetAllCritical>> getAllCritical() async {
    final response = await http.get(Uri.parse('$baseUrl/api/Graph/GetAllCritical'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      print('Critical Data Response: $data');
      return data.map((json) => GetAllCritical.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load critical data');
    }
  }

  // Method to get patient data by name
  Future<List<PatientDto>> getPatientDataByName(String name) async {
    final response = await http.get(Uri.parse('$baseUrl/api/Graph/$name'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      print('Patient Data Response: $data');
      return data.map((json) => PatientDto.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load patient data');
    }
  }

  // Method to get patient data filtered by date range
  Future<List<PatientDto>> getPatientDataByDateRange(
      String name, String fromDate, String toDate) async {
    // Validate inputs
    if (name.isEmpty || fromDate.isEmpty || toDate.isEmpty) {
      throw Exception('Invalid input parameters');
    }

    final String url = '$baseUrl/api/Graph/${name}/$fromDate/$toDate';
    print('Request URL: $url');

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        print('Filtered Patient Data Response: $data');
        return data.map((json) => PatientDto.fromJson(json)).toList();
      } else {
        print('API Error: ${response.statusCode}');
        throw Exception('Failed to fetch data: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error fetching data: $e');
      throw Exception('Failed to fetch data');
    }
  }

}
*/
