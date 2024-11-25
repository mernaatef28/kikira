import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:kikira/core/api/apiservicetoken.dart';
import 'package:kikira/core/classes/getallcritical.dart';
import 'package:kikira/core/theming/colors.dart';
import 'package:kikira/core/theming/localvariables.dart';
import 'package:kikira/core/theming/styles.dart';
import 'package:kikira/features/ui/screens/paitentdisplay.dart';

class CriticalBarChart extends StatefulWidget {
  const CriticalBarChart({Key? key}) : super(key: key);

  @override
  _CriticalBarChartState createState() => _CriticalBarChartState();
}

class _CriticalBarChartState extends State<CriticalBarChart> {
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
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(
              child: Text("Error loading critical data: ${snapshot.error}"));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text("No critical data available"));
        }

        final criticalData = snapshot.data!;
        return Padding(
          padding: const EdgeInsets.all(10.0),
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              maxY: (criticalData
                          .map((e) => e.count)
                          .reduce((a, b) => a > b ? a : b) +
                      5)
                  .toDouble(),
              barGroups: _buildBarGroups(criticalData),
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, _) =>
                        Text(value.toInt().toString()),
                  ),
                ),
                rightTitles:
                    AxisTitles(sideTitles: SideTitles(showTitles: false)),
                topTitles: AxisTitles(
                    axisNameWidget: Text(
                      "All criticals by date ",
                      style: TextStyle(
                          color: colorManager.kikiKohly,
                          fontWeight: FontWeight.bold,
                          fontSize: 15),
                    ),
                    sideTitles: SideTitles(
                      showTitles: false,
                    )),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, _) {
                      final index = value.toInt();
                      if (index >= 0 && index < criticalData.length) {
                        String date = criticalData[index].date.substring(5);
                        return Transform.rotate(
                          angle: -1.5708,
                          child: Text(
                            date,
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.black,
                            ),
                          ),
                        );
                      }
                      return const Text('');
                    },
                  ),
                ),
              ),
              borderData: FlBorderData(
                show: true,
                border: Border.all(),
              ),
              gridData: FlGridData(show: false),
              barTouchData: BarTouchData(
                touchTooltipData: BarTouchTooltipData(),
                touchCallback: (event, response) {
                  if (response != null && response.spot != null) {
                    final index = response.spot!.touchedBarGroupIndex;
                    final selectedData = criticalData[index];
                    _showPatientDetails(context, selectedData);
                  }
                },
              ),
            ),
          ),
        );
      },
    );
  }

  List<BarChartGroupData> _buildBarGroups(List<GetAllCritical> criticalData) {
    return List.generate(criticalData.length, (index) {
      final data = criticalData[index];
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: data.count.toDouble(),
            color: colorManager.kikilavander,
            width: 15,
          ),
        ],
        showingTooltipIndicators: [1],
      );
    });
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
              child: SingleChildScrollView(
                controller: scrollController,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Date: ${data.date}",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Text("Count: ${data.count}"),
                    SizedBox(height: 10),
                    Text(
                      "Patients at Risk:",
                      style: auraFontbold20,
                    ),
                    ...data.patients.map((patient) => Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20)),
                            child: ListTile(
                              title: Text(
                                patient.name,
                                style: aurabold25,
                              ),
                              subtitle: Text(
                                "State: ${patient.lastBiologicalIndicator.healthCondition}",
                                style: kikiFontRose15,
                              ),
                              trailing: MaterialButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Paitentdisplay(
                                          patientName: patient.name),
                                    ),
                                  );
                                },
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                color: colorManager.kikiYellow,
                                child: Icon(
                                  Icons.contact_page_outlined,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        )),
                  ],
                ),
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
