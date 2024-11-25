import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:kikira/core/api/apiservicetoken.dart';
import 'package:kikira/core/classes/getallcritical.dart';
import 'package:kikira/core/theming/colors.dart';
import 'package:kikira/core/theming/localvariables.dart';
import 'package:kikira/features/ui/screens/paitentdisplay.dart';

class CriticalLineChart extends StatefulWidget {
  const CriticalLineChart({Key? key}) : super(key: key);

  @override
  _CriticalLineChartState createState() => _CriticalLineChartState();
}

class _CriticalLineChartState extends State<CriticalLineChart> {
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
        // Filter invalid data and ensure counts are not null
        final validData = criticalData.where((e) => e.count != null).toList();

        if (validData.isEmpty) {
          return const Center(child: Text("No valid critical data available."));
        }

        // Calculate maxY safely
        final maxY = validData
            .map((e) => e.count!)
            .reduce((a, b) => a > b ? a : b)
            .toDouble() +
            5;

        return Padding(
          padding: const EdgeInsets.all(10.0),
          child: LineChart(
            LineChartData(
              maxY: maxY,
              minY: 0,
              lineBarsData: [
                LineChartBarData(
                  spots: _buildLineSpots(validData),
                  isCurved: true,
                  color: colorManager.kikiFirozi,
                  barWidth: 3,
                  dotData: FlDotData(show: true),
                  belowBarData: BarAreaData(
                    show: true,
                    gradient: LinearGradient(
                      colors: [
                        colorManager.kikiFirozi.withOpacity(0.3),
                        colorManager.kikilavander.withOpacity(0.1),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ],
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, _) {
                      if (value.isFinite) {
                        return Text(value.toInt().toString());
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ),
                rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                topTitles: AxisTitles(
                  axisNameWidget: Text(
                    "All criticals by date",
                    style: TextStyle(
                        color: colorManager.kikiFirozi,
                        fontWeight: FontWeight.bold,
                        fontSize: 15),
                  ),
                  sideTitles: SideTitles(showTitles: false),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, _) {
                      final index = value.toInt();
                      if (index >= 0 && index < validData.length) {
                        String date = validData[index].date.substring(5);
                        return Transform.rotate(
                          angle: -1.5708,
                          child: Text(
                            date,
                            style: const TextStyle(
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
                border: Border(top:BorderSide.none , right: BorderSide.none),
              ),
              gridData: FlGridData(show: true , drawVerticalLine : false ,drawHorizontalLine :true ,),
              lineTouchData: LineTouchData(
                touchTooltipData: LineTouchTooltipData(
                  getTooltipItems: (spots) {
                    return spots.map((spot) {
                      final dataIndex = spot.x.toInt();
                      final data = validData[dataIndex];
                      return LineTooltipItem(
                        "${data.date}\nCount: ${data.count}",
                        const TextStyle(color: Colors.black),
                      );
                    }).toList();
                  },
                ),
                touchCallback: (event, response) {
                  if (response != null &&
                      response.lineBarSpots != null &&
                      response.lineBarSpots!.isNotEmpty) {
                    final index = response.lineBarSpots!.first.x.toInt();
                    final selectedData = validData[index];
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

  List<FlSpot> _buildLineSpots(List<GetAllCritical> criticalData) {
    return List.generate(
      criticalData.length,
          (index) => FlSpot(
        index.toDouble(),
        criticalData[index].count!.toDouble(),
      ),
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
              child: SingleChildScrollView(
                controller: scrollController,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
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
                                        patientName: patient.name, hospitalName: getHospitalName(patient.hospitalId),),
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
              ),
            );
          },
        );
      },
    );
  }
}
String getHospitalName(int hospitalId) {
  var hospital = hospitals.firstWhere(
        (hospital) => hospital['id'] == hospitalId,
    orElse: () => {'name': 'Unknown'},
  );
  return hospital['name'];
}