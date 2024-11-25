import 'package:flutter/material.dart';
import 'package:kikira/core/api/geminiservice.dart';
import 'package:kikira/core/classes/patientdto.dart';
import 'package:kikira/core/theming/colors.dart';

import 'apiservicetoken.dart';

class GemimiApp extends StatefulWidget {
  const GemimiApp({super.key});

  @override
  State<GemimiApp> createState() => _GemimiAppState();
}

class _GemimiAppState extends State<GemimiApp> {
  String? responseText;// State variable to hold API response
  List<PatientDto> patientData = [];
  @override
  void initState() {
    super.initState();
    fetchResponse(); // Fetch response on init
  }

  // Fetch response from Gemini API
  void fetchResponse() async {
    try {
      final ApiService apiService = ApiService();
      var data = await apiService.getPatientDataByName("John Doe");
      String requestText = data.join(" "); // Combine list into one string
      print(requestText) ;
      // Step 3: Send the combined text to the Gemini API
      String? geminiResponse = await GeminiService().getResponse(requestText);
      print (geminiResponse) ;
      setState(() {
        responseText = geminiResponse;// Update state with the response
      });
    } catch (e) {
      print('Error fetching response: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorManager.kikiKohly,
        title: const Text("Gemini API Response"),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: colorManager.kikiKohly,
          padding: const EdgeInsets.all(16.0),
          child: Text(
            responseText ?? "Fetching response...", // Display response or loading message
            style: const TextStyle(fontSize: 16, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
