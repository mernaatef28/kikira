import 'package:flutter/material.dart';
import 'apiservice.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final ApiService apiService = ApiService();
  List<String> names = [];
  List<PatientDto> patientData = [];
  final String name = "John Doe" ;

  @override
  void initState() {
    super.initState();
    fetchAllNames();
  }

  // Fetch all names
  void fetchAllNames() async {
    try {
      var data = await apiService.getAllNames();
      setState(() {
        names = data;
      });
    } catch (e) {
      print('Error fetching names: $e');
    }
  }

  // Fetch patient data by name
  void fetchPatientData(String name  ) async {
    try {
      var data = await apiService.getPatientDataByName(name);
      setState(() {
        patientData = data;
      });
    } catch (e) {
      print('Error fetching patient data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('HospitalML API')),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () => fetchPatientData(name), // Replace with actual name
            child: Text('Fetch Patient Data'),
          ),
          // Display fetched names
          if (names.isNotEmpty)
            Text('Names: ${names.join(", ")}'),
          // Display patient data
          if (patientData.isNotEmpty)
            Expanded(
              child: ListView.builder(
                itemCount: patientData.length,
                itemBuilder: (context, index) {
                  final patient = patientData[index];
                  return Column(

                    children: [
                      Text("patient name : $name"),
                      ListTile(
                        title: Text('Sugar: ${patient.sugarPercentage}'),
                        subtitle: Text('Date: ${patient.date} Time: ${patient.time}'),
                      ),
                    ],
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
