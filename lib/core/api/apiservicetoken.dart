import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:kikira/core/classes/getallcritical.dart';
import 'package:kikira/core/classes/gethospitals.dart';
import 'package:kikira/core/classes/patientdto.dart';
import 'package:kikira/core/classes/patientdtoname.dart';
import 'package:kikira/core/classes/user.dart';
//import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
class ApiService {
  final String baseUrl = 'https://anteshnatsh.tryasp.net';
   String? _token , username , userHospitalName; // Private variable to store the token



  // Login method that sets the token
  Future<User> login(String email, String password) async {
    final url = Uri.parse('$baseUrl/api/Account/Login');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'accept': 'text/plain',
        },
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        _token = responseData['token'];
        username= responseData['username'];
        userHospitalName = responseData['hospitalName'];
        //_token = _token?.replaceAll('\n', '').trim();
        //_token = "eyJhbGciOiJodHRwOi8vd3d3LnczLm9yZy8yMDAxLzA0L3htbGRzaWctbW9yZSNobWFjLXNoYTI1NiIsInR5cCI6IkpXVCJ9.eyJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9lbWFpbGFkZHJlc3MiOiJ2aWN0b3JuaXNlbTAxQGdtYWlsLmNvbSIsImh0dHA6Ly9zY2hlbWFzLm1pY3Jvc29mdC5jb20vd3MvMjAwOC8wNi9pZGVudGl0eS9jbGFpbXMvcm9sZSI6IlVzZXIiLCJleHAiOjE3MzI4MzcwOTIsImlzcyI6Imh0dHBzOi8vYW50ZXNobmF0c2gudHJ5YXNwLm5ldCIsImF1ZCI6Ik15U2VjdXJlS2V5In0.WJDfzQTL1SA6VPCM4ct123Gif76lHj8acSQDYUCamDg" ;

        // Set the token
        saveToken(_token!) ;
        print('Token updated: $_token');

        // save username and hospitalname on the local storage
        saveUserNameandHospitalName(username!, userHospitalName!  ) ;
        print ("username and hospitalname passed to save function  ") ;

        return User.fromJson(responseData);
      } else {
        print('Login failed: ${response.statusCode}');
        throw Exception('Login failed');
      }
    } catch (e) {
      print('Error during login: $e');
      throw Exception('Error during login: $e');
    }
  }



// Create a secure storage instance
  final storage = FlutterSecureStorage();

// Save token
  Future<void> saveToken(String token) async {
    await storage.write(key: 'auth_token', value: token);
  }

// Retrieve token
  Future<String?> getToken() async {
    return await storage.read(key: 'auth_token');
  }

// Delete token
  Future<void> deleteToken() async {
    await storage.delete(key: 'auth_token');
  }

// Save token
  Future<void> saveUserNameandHospitalName(String username , String userHospitalName) async {
    await storage.write(key: 'username', value: username);
    await storage.write(key: 'userHospitalName', value: userHospitalName);
  }

// Retrieve token
  Future<String?> getsavedUserName() async {
    return await storage.read(key: 'username');
  }
  Future<String?> getsavedUserHospitalName() async {
    return await storage.read(key: 'userHospitalName');
  }

  // Example of using the token in an API call
  Future<List<PatientDtoName>> getAllNames() async {
    //_token = "eyJhbGciOiJodHRwOi8vd3d3LnczLm9yZy8yMDAxLzA0L3htbGRzaWctbW9yZSNobWFjLXNoYTI1NiIsInR5cCI6IkpXVCJ9.eyJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9lbWFpbGFkZHJlc3MiOiJ2aWN0b3JuaXNlbTAxQGdtYWlsLmNvbSIsImh0dHA6Ly9zY2hlbWFzLm1pY3Jvc29mdC5jb20vd3MvMjAwOC8wNi9pZGVudGl0eS9jbGFpbXMvcm9sZSI6IlVzZXIiLCJleHAiOjE3MzI4MzcwOTIsImlzcyI6Imh0dHBzOi8vYW50ZXNobmF0c2gudHJ5YXNwLm5ldCIsImF1ZCI6Ik15U2VjdXJlS2V5In0.WJDfzQTL1SA6VPCM4ct123Gif76lHj8acSQDYUCamDg" ;
    final _token = await getToken();
    print(_token) ;
    if (_token == null) {
      throw Exception('User is not logged in. Token is missing.');
    }

    final url = Uri.parse('$baseUrl/api/Graph/AllNames');

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $_token',
          'Content-Type': 'application/json',
        },

      );
      print(response) ;

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        print('All Names Response: $data');
        return data.map((json) => PatientDtoName.fromJson(json)).toList();
      } else {
        print("${response.reasonPhrase}") ;
        throw Exception('Failed to load names response state code : ${response.statusCode}');

      }
    } catch (e) {
      print('Error fetching names: $e');
      throw Exception('Failed to fetch names');
    }

  }

  // Method to get all critical data
  Future<List<GetAllCritical>> getAllCritical() async {

    final url = Uri.parse('$baseUrl/api/Graph/GetAllCritical');
    final _token= await getToken() ;
    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $_token',
          'Content-Type': 'application/json',
        },

      );
      print(response);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        print('Critical Data Response: $data');
        return data.map((json) => GetAllCritical.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load critical data');
      }

    }
    catch (e) {
      print('Error fetching criticals : $e');
      throw Exception('Failed to fetch criticals');
    }
  }
    // Other methods use the token in the same way
  Future<List<PatientDto>> getPatientDataByDateRange(
      String name, String fromDate, String toDate) async {
    // Validate inputs
    if (name.isEmpty || fromDate.isEmpty || toDate.isEmpty) {
      throw Exception('Invalid input parameters');
    }

    final _token = await getToken();
    if (_token == null) {
      throw Exception('User is not logged in. Token is missing.');
    }

    final url = Uri.parse(
        '$baseUrl/api/Graph/${name}/${Uri.encodeComponent(fromDate)}/${Uri.encodeComponent(toDate)}');

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $_token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> responseData = jsonDecode(response.body);
        print('Filtered Patient Data Response: $responseData');
        return responseData.map((json) => PatientDto.fromJson(json)).toList();
      } else {
        print('API Error Response: ${response.body}');
        throw Exception('Failed to fetch patient data: ${response.statusCode}');
      }
    } catch (e, stackTrace) {
      print('Error fetching patient data: $e');
      print('StackTrace: $stackTrace');
      throw Exception('Failed to fetch data');
    }
  }

  Future<List<PatientDto>> getPatientDataByName(String name) async {
    final url = Uri.parse('$baseUrl/api/Graph/$name') ;
    final _token= await getToken() ;
    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $_token',
          'Content-Type': 'application/json',
        },

      );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      print('Patient Data Response: $data');
      return data.map((json) => PatientDto.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load patient data');
    }
  }
    catch (e) {
      print('Error fetching name:$name $e');
      throw Exception('Failed to fetch name');
    }
//hospitals that this admin has access on :

  }
Future<List<GetHospitals>> getHospitalsDetails () async {
  final url = Uri.parse('$baseUrl/api/Hospital/GetHospitals');
  final _token= await getToken() ;
  try {
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $_token',
        'Content-Type': 'application/json',
      },

    );
    print(response);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      print('Hospitals Data Response: $data');
      return data.map((json) => GetHospitals.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load hospitals data');
    }

  }
  catch (e) {
    print('Error fetching hospitals : $e');
    throw Exception('Failed to fetch hospitals ');
  }

}
}

