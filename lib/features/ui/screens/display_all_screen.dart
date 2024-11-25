import 'package:flutter/material.dart';
import 'package:kikira/core/api/apiservicetoken.dart';
import 'package:kikira/core/classes/patientdtoname.dart';
import 'package:kikira/core/theming/colors.dart';
import 'package:kikira/core/theming/localvariables.dart';
import 'package:kikira/features/ui/screens/paitentdisplay.dart';
import 'package:kikira/features/ui/widgets/Indivisualcard_widget.dart';
import 'package:kikira/features/ui/widgets/piechart.dart';

class DisplayAllScreen extends StatefulWidget {
  final String hospitalName;
  final String BioIndicatorFilter;

  const DisplayAllScreen({
    super.key,
    required this.hospitalName,
    required this.BioIndicatorFilter,
  });

  @override
  State<DisplayAllScreen> createState() => _DisplayAllScreenState();
}

class _DisplayAllScreenState extends State<DisplayAllScreen> {
  final ApiService apiService = ApiService();
  late Future<List<PatientDtoName>> futureNames;

  int counterAtRisk = 0;
  int counterHealthy = 0;

  @override
  void initState() {
    super.initState();
    futureNames = apiService.getAllNames();
  }

  String determineState(PatientDtoName patient) {
    if (widget.BioIndicatorFilter == "Temperature") {
      dynamic temp = patient.lastBiologicalIndicator.averageTemprature;
      if (temp > 37.5 || temp < 36.5) return "At Risk";
      return "Healthy";
    } else if (widget.BioIndicatorFilter == "Sugar Percentage") {
      dynamic sugar = patient.lastBiologicalIndicator.sugarPercentage;
      if (sugar > 100 || sugar < 50) return "At Risk";
      return "Healthy";
    } else if (widget.BioIndicatorFilter == "Blood Pressure") {
      dynamic bp = patient.lastBiologicalIndicator.bloodPressure;
      if (bp > 120 || bp < 80) return "At Risk";
      return "Healthy";
    } else if (widget.BioIndicatorFilter == "State") {
      dynamic healthCondition = patient.lastBiologicalIndicator.healthCondition;
      if (healthCondition == "At Risk") return "At Risk";
      return "Healthy";
    }
    return "EMPTY";
  }

  Color determineCardColor(String state) {
    switch (state) {
      case "At Risk":
        return Colors.redAccent;
      case "Healthy":
        return Colors.greenAccent;
      default:
        return Colors.grey;
    }
  }

  String getHospitalName(int hospitalId) {
    var hospital = hospitals.firstWhere(
          (hospital) => hospital['id'] == hospitalId,
      orElse: () => {'name': 'Unknown'},
    );
    return hospital['name'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorManager.kikiFirozi,
        title: Text(widget.BioIndicatorFilter, style: const TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_outlined, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions:<Widget> [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(icon : Icon(Icons.pie_chart_rounded) , color: colorManager.kikiGray,onPressed: (){showDialog(
              context: context,
              builder: (BuildContext context) {
                return PieChartSample2(atRiskCount: counterAtRisk, healthyCount: counterHealthy, );
              },
            );},),
          ),

        ],
        actionsIconTheme: IconThemeData(
          size: 30,
          color: Colors.white ,

        ),
      ),
      body: Container(
        child: FutureBuilder<List<PatientDtoName>>(
          future: futureNames,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(
                child: Text("Error fetching data: ${snapshot.error}"),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text("No patient data available"));
            }

            // Reset counters before calculating new ones
            counterAtRisk = 0;
            counterHealthy = 0;

            // Filter patients
            List<PatientDtoName> filteredPatients = snapshot.data!;

            // Sort by health condition
            filteredPatients.sort((a, b) {
              const order = {"At Risk": 1, "Healthy": 2, "EMPTY": 3};
              String stateA = determineState(a);
              String stateB = determineState(b);
              return order[stateA]!.compareTo(order[stateB]!);
            });

            // Update counters
            for (var patient in filteredPatients) {
              String state = determineState(patient);
              if (state == "At Risk") {
                counterAtRisk++;
              } else if (state == "Healthy") {
                counterHealthy++;
              }
            }

            return ListView(
              padding: const EdgeInsets.all(10),
              children: filteredPatients.map((patient) {
                String patientState = determineState(patient);
                Color cardColor = determineCardColor(patientState);

                return IndivisualCard_Widget(
                  paitentId: "ID_${patient.id}",
                  paitentName: patient.name,
                  addproductName: patient.name,
                  patientDisplayPush: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            Paitentdisplay(patientName: patient.name, hospitalName: getHospitalName(patient.hospitalId),),
                      ),
                    );
                  },
                  cardColor: cardColor,
                  goToChart: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Paitentdisplay(
                          patientName: patient.name,
                          scrollToChart: true, hospitalName: getHospitalName(patient.hospitalId),
                        ),
                      ),
                    );
                  },
                  hospitalName: getHospitalName(patient.hospitalId),
                );
              }).toList(),
            );
          },
        ),
      ),
    );
  }
}

/*  int getHospitalId(String hospitalName) {
    var hospital = hospitals.firstWhere((hospital) => hospital['name'] == hospitalName, orElse: () => {'id': -1});
    return hospital['id'];
  }*/