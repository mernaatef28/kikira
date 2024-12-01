import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:kikira/core/classes/getallcritical.dart';
import 'package:kikira/core/classes/gethospitals.dart';
import 'package:kikira/core/classes/patientdto.dart';
import 'package:kikira/core/classes/patientdtoname.dart';
import 'package:kikira/core/classes/user.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiService {
  final String baseUrl = 'https://anteshnatsh.tryasp.net';

  // Variables for token and user info
  String? _token;
  String? username;
  String? userHospitalName;

  // Secure storage instance
  final storage = FlutterSecureStorage();

  /// Login method that sets the token and user details
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
        username = responseData['username'];
        userHospitalName = responseData['hospitalName'];

        await saveToken(_token!);
        await saveUserNameandHospitalName(username!, userHospitalName!);
        print('Token updated: $_token');
        print('Login successful: Token updated.');
        return User.fromJson(responseData);
      } else {
        throw Exception(
            'Login failed with status code: ${response.statusCode}');
      }
    } catch (e, stackTrace) {
      print('Error during login: $e');
      print('StackTrace: $stackTrace');
      throw Exception('Error during login: $e');
    }
  }

  /// Save token in secure storage
  Future<void> saveToken(String token) async {
    await storage.write(key: 'auth_token', value: token);
  }

  /// Retrieve token from secure storage
  Future<String?> getToken() async {
    return await storage.read(key: 'auth_token');
  }

  /// Delete token from secure storage
  Future<void> deleteToken() async {
    await storage.delete(key: 'auth_token');
  }

// Save token
  Future<void> saveUserNameandHospitalName(String username,
      String userHospitalName) async {
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
    final _token = await getToken();
    print(_token);
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

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        print('All Names Response: $data');
        return data.map((json) => PatientDtoName.fromJson(json)).toList();
      } else {
        throw Exception(
            'Failed to fetch names. Status code: ${response.statusCode}');
      }
    } catch (e, stackTrace) {
      print('Error fetching names: $e');
      print('StackTrace: $stackTrace');
      throw Exception('Error fetching names: $e');
    }
  }

  /// Fetch all critical data
  Future<List<GetAllCritical>> getAllCritical() async {
    final url = Uri.parse('$baseUrl/api/Graph/GetAllCritical');
    final _token = await getToken();

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $_token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final responseBody = response.body;

        // Check if response body is empty or null
        if (responseBody == null || responseBody.isEmpty) {
          throw Exception('Empty response body from the API');
        }

        final List<dynamic> data = json.decode(responseBody);

        // Check if data is null or empty after decoding
        if (data == null || data.isEmpty) {
          throw Exception('No critical data found');
        }

        return data.map((json) => GetAllCritical.fromJson(json)).toList();
      } else {
        throw Exception('Failed to fetch critical data. Status code: ${response.statusCode}');
      }
    } catch (e, stackTrace) {
      print('Error fetching critical data: $e');
      print('StackTrace: $stackTrace');
      throw Exception('Error fetching critical data: $e');
    }
  }




  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();

// Save critical data with the current date

  Future<void> saveCriticalDataWithDate(List<GetAllCritical> data) async {
    // Convert the GetAllCritical list to a list of maps
    final jsonData = json.encode(
      data.map((e) => {
        'count': e.count,
        'date': e.date,
        'patients': e.patients.map((patient) => {
          'id': patient.id,
          'name': patient.name,
          'hospitalId': patient.hospitalId,
        }).toList(),
      }).toList(),
    );

    final currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    await _secureStorage.write(key: 'criticalData', value: jsonData);
    await _secureStorage.write(key: 'criticalDataDate', value: currentDate);
  }

// Load critical data, resetting if the date is not today's date
  Future<List<GetAllCritical>> loadCriticalData() async {
    final storedDate = await _secureStorage.read(key: 'criticalDataDate');
    final todayDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

    if (storedDate == null || storedDate != todayDate) {
      // If there's no stored date or the stored date is not today, reset the data
      await _secureStorage.write(key: 'criticalData', value: null);
      await _secureStorage.write(key: 'criticalDataDate', value: todayDate);
      return [];
    }

    final storedData = await _secureStorage.read(key: 'criticalData');

    // If storedData is null, return an empty list
    if (storedData == null) {
      return [];
    }

    try {
      return (json.decode(storedData) as List)
          .map((json) => GetAllCritical.fromJson(json))
          .toList();
    } catch (e) {
      // In case of invalid JSON data
      print('Error decoding stored data: $e');
      return [];
    }
  }


  /// Fetch patient data by date range
  Future<List<PatientDto>> getPatientDataByDateRange(String name,
      String fromDate, String toDate) async {
    if (name.isEmpty || fromDate.isEmpty || toDate.isEmpty) {
      throw Exception('Invalid input parameters.');
    }

    final _token = await getToken();
    if (_token == null) {
      throw Exception('User is not logged in. Token is missing.');
    }

    final url = Uri.parse(
        '$baseUrl/api/Graph/$name/${Uri.encodeComponent(fromDate)}/${Uri
            .encodeComponent(toDate)}');

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
        throw Exception('Failed to fetch patient data. Status code: ${response
            .statusCode}');
      }
    } catch (e, stackTrace) {
      print('Error fetching patient data: $e');
      print('StackTrace: $stackTrace');
      throw Exception('Error fetching patient data: $e');
    }
  }


  Future<List<PatientDto>> getPatientDataByName(String name) async {
    final url = Uri.parse('$baseUrl/api/Graph/$name');
    final _token = await getToken();
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
  }

//hospitals that this admin has access on :

  /// Fetch hospital details
  Future<List<GetHospitals>> getHospitalsDetails() async {
    final token = await getToken();
    if (token == null) throw Exception('Token is missing.');

    final url = Uri.parse('$baseUrl/api/Hospital/GetHospitals');

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

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