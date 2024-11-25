import 'package:flutter/material.dart';
import 'package:kikira/core/api/apiservicetoken.dart';
import 'package:kikira/core/classes/patientdto.dart';
import 'package:kikira/core/theming/colors.dart';
import 'package:kikira/features/ui/widgets/chartpatient.dart';
import 'package:kikira/features/ui/widgets/dataCard.dart';

class PatientDateAfterFilter extends StatefulWidget {
  final String name;
  final String fromDate;
  final String toDate;
  final String nameforHeader ;

  const PatientDateAfterFilter({
    required this.name,
    required this.fromDate,
    required this.toDate,
    super.key,
    required this.nameforHeader,
  });

  @override
  _PatientDateAfterFilterState createState() => _PatientDateAfterFilterState();
}

class _PatientDateAfterFilterState extends State<PatientDateAfterFilter> {
  bool isLoading = true;
  List<PatientDto> patientData = [];
  final ApiService apiService = ApiService();

  @override
  void initState() {
    super.initState();
    fetchPatientData();
  }

  Future<void> fetchPatientData() async {
    try {
      final data = await apiService.getPatientDataByDateRange(
        widget.name,
        widget.fromDate,
        widget.toDate,
      );
      setState(() {
        patientData = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching data: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorManager.kikiKohly,
        title: Text(widget.nameforHeader, style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_outlined, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Column(
          children: [
            if (patientData.isNotEmpty)
              ...patientData.map((patient) {
                return dataCard(
                  date: patient.date,
                  time: patient.time,
                  SugerPersentage: patient.sugarPercentage.toString(),
                  averageTemprature: patient.averageTemprature.toString(),
                  bloodPressure: patient.bloodPressure.toString(),
                );
              }).toList()
            else
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'No patient data available.',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ),
              ),
            SizedBox(height: 20),
            Text("Sugar Percentage Chart", style: TextStyle(fontSize: 20)),
            SizedBox(
              height: 300,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: LineChartWidget(patientData: patientData, metric: 'sugarPercentage',),
              ),
            ),
            SizedBox(height: 20),
            Text("Average Temperature Chart", style: TextStyle(fontSize: 20)),
            SizedBox(
              height: 300,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: LineChartWidget(patientData: patientData, metric: 'averageTemperature',),
              ),
            ),
            SizedBox(height: 20),
            Text("Blood Pressure Chart", style: TextStyle(fontSize: 20)),
            SizedBox(
              height: 300,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: LineChartWidget(patientData: patientData, metric: 'bloodPressure',),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
