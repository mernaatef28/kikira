import 'package:flutter/material.dart';
import 'package:kikira/core/api/apiservice.dart';
import 'package:kikira/core/theming/colors.dart';
import 'package:kikira/features/ui/screens/paitentdisplay.dart';
import 'package:kikira/features/ui/widgets/Indivisualcard_widget.dart';
import 'package:kikira/kiki_app.dart';

class DisplayAllScreen extends StatefulWidget {
  const DisplayAllScreen({super.key});

  @override
  State<DisplayAllScreen> createState() => _DisplayAllScreenState();
}

class _DisplayAllScreenState extends State<DisplayAllScreen> {
  final ApiService apiService = ApiService();
  late Future<List<String>> futureNames;
  late Future<List<PatientDto>> futurePatientNameData;

  @override
  void initState() {
    super.initState();
    futureNames = apiService.getAllNames(); // Initialize the Future for fetching names
    print("futureNames initialized in initState");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorManager.kikiKohly,
        title: Text('Display All', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_outlined, color: Colors.white),
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => kiki_Ra_app()));
          },
        ),
      ),
      body: Container(
        color: colorManager.kikiKohly,
        child: FutureBuilder<List<String>>(
          future: futureNames,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text("Error fetching data: ${snapshot.error}"));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text("No patient data available"));
            }

            // Display fetched data using IndivisualCard_Widget
            return ListView(
              padding: EdgeInsets.all(10),
              children: snapshot.data!.map((name) {
                return IndivisualCard_Widget(
                  paitentId: "ID_$name", // Replace with actual patient ID if available
                  paitentName: name,
                  addproductName: name, // Adjust based on your model
                  patientDisplayPush: () {
                    // Define action for viewing patient details
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Paitentdisplay(patientName: name ), // Adjust as needed
                      ),
                    );
                  },
                  deletePatient: (id) {
                    // Implement delete functionality
                  },
                );
              }).toList(),

            );
          },
        ),
      ),
    );
  }
}
