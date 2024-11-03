
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:kikira/core/api/apiservice.dart';

class LineChartWidget extends StatelessWidget {
  final List<PatientDto> patientData;

  const LineChartWidget({Key? key, required this.patientData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<FlSpot> spots = [];

    // Create FlSpot for the chart
    for (var patient in patientData) {
      DateTime date = DateTime.parse(patient.date); // Adjust according to your date format
      double yValue = double.parse(patient.sugarPercentage.toString());
      spots.add(FlSpot(date.millisecondsSinceEpoch.toDouble(), yValue));
    }

    return LineChart(
      LineChartData(
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: true, reservedSize: 40),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: true, reservedSize: 40),
          ),
        ),
        gridData: FlGridData(show: true),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: Colors.blue,
            dotData: FlDotData(show: true),
            belowBarData: BarAreaData(show: false),
          ),
        ],
        borderData: FlBorderData(
          show: true,
          border: Border.all(color: Colors.black, width: 1),
        ),
      ),
    );
  }
}
