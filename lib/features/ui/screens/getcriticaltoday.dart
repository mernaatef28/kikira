import 'package:flutter/material.dart';
import 'package:kikira/core/api/apiservicetoken.dart';
import 'package:kikira/core/classes/getallcritical.dart';
import 'package:kikira/core/theming/colors.dart';
import 'package:kikira/core/theming/localvariables.dart';
import 'package:kikira/features/ui/screens/paitentdisplay.dart';

class CriticalToday extends StatefulWidget {
  const CriticalToday({Key? key}) : super(key: key);

  @override
  _CriticalTodayState createState() => _CriticalTodayState();
}

class _CriticalTodayState extends State<CriticalToday> {
  final ApiService apiService = ApiService();
  late Future<List<GetAllCritical>> futureCriticalData;

  @override
  void initState() {
    super.initState();
    futureCriticalData = apiService.getAllCritical();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<GetAllCritical>>(
      future: futureCriticalData,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(
              child: Text("Error loading critical data: ${snapshot.error}"));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("No critical data available"));
        }

        final criticalData = snapshot.data!;

        // Get today's date
        final today = DateTime.now();
        final todayFormatted = "2024-11-10"; // Replace this with actual date formatting if needed

        // Filter critical data for today
        final todayCriticals = criticalData.where((e) => e.date.substring(0, 10) == todayFormatted).toList();

        if (todayCriticals.isEmpty) {
          return const Center(child: Text("No critical data for today."));
        }

        return ListView.builder(
          itemCount: todayCriticals.length,
          itemBuilder: (context, index) {
            final data = todayCriticals[index];
            return ListTile(
              title: Text("Date: ${data.date}"),
              subtitle: Text("Count: ${data.count}"),
              trailing: MaterialButton(
                onPressed: () {
                  _showPatientDetails(context, data);
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                color: colorManager.kikiYellow,
                child: const Icon(
                  Icons.contact_page_outlined,
                  color: Colors.white,
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showPatientDetails(BuildContext context, GetAllCritical data) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.5,
          maxChildSize: 0.9,
          builder: (context, scrollController) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                controller: scrollController,
                children: [
                  Text(
                    "Date: ${data.date}",
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text("Count: ${data.count}"),
                  const SizedBox(height: 10),
                  const Text("Patients at Risk:",
                      style: TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold)),
                  ...data.patients.map(
                        (patient) => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20)),
                        child: ListTile(
                          title: Text(patient.name ?? '',
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                          subtitle: Text("State: ${patient.lastBiologicalIndicator.healthCondition ?? ''}"),
                          trailing: MaterialButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Paitentdisplay(
                                    patientName: patient.name,
                                    hospitalName: getHospitalName(patient.hospitalId),
                                  ),
                                ),
                              );
                            },
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                            color: colorManager.kikiYellow,
                            child: const Icon(
                              Icons.contact_page_outlined,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  String getHospitalName(int hospitalId) {
    var hospital = hospitals.firstWhere(
          (hospital) => hospital['id'] == hospitalId,
      orElse: () => {'name': 'Unknown'},
    );
    return hospital['name'];
  }
}
