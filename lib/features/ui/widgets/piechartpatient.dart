import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kikira/core/classes/patientdto.dart';

class PieChartWidget extends StatelessWidget {
  final List<PatientDto> patientData;
  final String metric;

  const PieChartWidget({
    Key? key,
    required this.patientData,
    required this.metric,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Sort patientData by date and time
    patientData.sort((a, b) {
      DateTime dateA = DateFormat('yyyy-MM-dd').parse(a.date);
      DateTime timeA = DateFormat('H:mm:ss').parse(a.time);
      DateTime dateTimeA = DateTime(dateA.year, dateA.month, dateA.day,
          timeA.hour, timeA.minute, timeA.second);

      DateTime dateB = DateFormat('yyyy-MM-dd').parse(b.date);
      DateTime timeB = DateFormat('H:mm:ss').parse(b.time);
      DateTime dateTimeB = DateTime(dateB.year, dateB.month, dateB.day,
          timeB.hour, timeB.minute, timeB.second);

      return dateTimeA.compareTo(dateTimeB);
    });

    // Calculate the sum of values based on the selected metric
    double totalValue = 0;
    List<Map<String, dynamic>> pieData = [];

    for (var patient in patientData) {
      double value;
      if (metric == 'sugarPercentage') {
        value = double.parse(patient.sugarPercentage.toString());
      } else if (metric == 'averageTemperature') {
        value = double.parse(patient.averageTemprature.toString());
      } else if (metric == 'bloodPressure') {
        value = double.parse(patient.bloodPressure.toString());
      } else {
        value = 0; // Fallback for unknown metrics
      }

      totalValue += value;
      pieData.add({
        'value': value,
        'label': '${patient.date} ${patient.time}',
      });
    }

    // Generate PieChart sections
    List<PieChartSectionData> sections = pieData.map((data) {
      final value = data['value'] as double;
      final percentage = (value / totalValue * 100).toStringAsFixed(1);

      return PieChartSectionData(
        value: value,
        title: '$percentage%',
        color: Colors.primaries[pieData.indexOf(data) % Colors.primaries.length],
        radius: 50,
        titleStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();

    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: Colors.white,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Metric Distribution',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 300, // Set explicit height
              width: 300,  // Set explicit width
              child: PieChart(
                PieChartData(
                  sections: sections,
                  centerSpaceRadius: 40,
                  borderData: FlBorderData(show: false),
                  sectionsSpace: 2,
                ),
              ),
            ),
            const SizedBox(height: 10),
            // Legend
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 10,
              children: pieData.map((data) {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      color: Colors.primaries[
                      pieData.indexOf(data) % Colors.primaries.length],
                    ),
                    const SizedBox(width: 5),
                    Text(
                      data['label'] as String,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
