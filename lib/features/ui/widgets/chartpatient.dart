import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kikira/core/classes/patientdto.dart';
import 'package:kikira/core/theming/colors.dart';
import 'package:kikira/core/theming/styles.dart';

class LineChartWidget extends StatelessWidget {
  final List<PatientDto> patientData;
  final String metric; // Metric to display: sugarPercentage, averageTemperature, bloodPressure

  const LineChartWidget({
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
      DateTime dateTimeA = DateTime(
          dateA.year, dateA.month, dateA.day, timeA.hour, timeA.minute, timeA.second);

      DateTime dateB = DateFormat('yyyy-MM-dd').parse(b.date);
      DateTime timeB = DateFormat('H:mm:ss').parse(b.time);
      DateTime dateTimeB = DateTime(
          dateB.year, dateB.month, dateB.day, timeB.hour, timeB.minute, timeB.second);

      return dateTimeA.compareTo(dateTimeB);
    });

    List<FlSpot> spots = [];

    // Create FlSpot based on the selected metric
    for (var patient in patientData) {
      DateTime date = DateFormat('yyyy-MM-dd').parse(patient.date);
      DateTime time = DateFormat('H:mm:ss').parse(patient.time);
      DateTime dateTime = DateTime(
          date.year, date.month, date.day, time.hour, time.minute, time.second);

      double yValue;
      if (metric == 'sugarPercentage') {
        yValue = double.parse(patient.sugarPercentage.toString());
      } else if (metric == 'averageTemperature') {
        yValue = double.parse(patient.averageTemprature.toString());
      } else if (metric == 'bloodPressure') {
        yValue = double.parse(patient.bloodPressure.toString());
      } else {
        yValue = 0; // Fallback if an unknown metric is provided
      }

      spots.add(FlSpot(dateTime.millisecondsSinceEpoch.toDouble(), yValue));
    }

    // Determine min and max x and y values
    double minX = spots.isNotEmpty
        ? spots.map((spot) => spot.x).reduce((a, b) => a < b ? a : b)
        : 0;
    double maxX = spots.isNotEmpty
        ? spots.map((spot) => spot.x).reduce((a, b) => a > b ? a : b)
        : 0;
    double minY = spots.isNotEmpty
        ? spots.map((spot) => spot.y).reduce((a, b) => a < b ? a : b)
        : 0;
    double maxY = spots.isNotEmpty
        ? spots.map((spot) => spot.y).reduce((a, b) => a > b ? a : b)
        : 0;

    // Set default intervals if there's only one unique x or y value
    double xInterval = (maxX - minX) != 0 ? (maxX - minX) / 4 : 1;
    double yInterval = (maxY - minY) != 0 ? (maxY - minY) / 5 : 1;

    String formatTime(double value) {
      final date = DateTime.fromMillisecondsSinceEpoch(value.toInt());
      return DateFormat('yyyy-MM-dd').format(date); // Format as a date
    }

    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: Colors.white,
        ),
        child: LineChart(
          LineChartData(
            minX: minX,
            maxX: maxX,
            minY: minY,
            maxY: maxY > 0 ? maxY : 1,
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 40,
                  interval: yInterval,
                  getTitlesWidget: (value, meta) => Text(
                    value.toStringAsFixed(1),
                    style: const TextStyle(fontSize: 10),
                  ),
                ),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 60, // Adjust for vertical text
                  getTitlesWidget: (value, meta) => RotatedBox(
                    quarterTurns: 1, // Rotate text vertically
                    child: Padding(
                      padding: const EdgeInsets.only(left:8.0),
                      child: Text(
                        formatTime(value),
                        style: const TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            ),
            borderData: FlBorderData(
              show: true,
              border: Border(
                top: BorderSide.none,
                right: BorderSide.none,
              ),
            ),
            gridData: FlGridData(
              show: true,
              drawVerticalLine: false,
              drawHorizontalLine: true,
            ),
            lineBarsData: [
              LineChartBarData(
                spots: spots,
                isCurved: true,
                color: colorManager.kikiFirozi,
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
            lineTouchData: LineTouchData(
              touchTooltipData: LineTouchTooltipData(
                tooltipPadding: const EdgeInsets.all(0),
                tooltipMargin: 0,
                // Return a list of tooltips for each touched spot
                getTooltipItems: (touchedSpots) {
                  return touchedSpots.map((spot) {
                    final date = DateTime.fromMillisecondsSinceEpoch(spot.x.toInt());
                    final biologicalIndicatorValue = spot.y;
                    final biologicalIndicatorName = metric;
                    return LineTooltipItem(
                      "$biologicalIndicatorName: ${biologicalIndicatorValue.toStringAsFixed(2)}",
                      TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    );
                  }).toList(); // Generate tooltips for each touched spot
                },
              ),
              touchCallback: (event, response) {
                if (event.isInterestedForInteractions &&
                    response != null &&
                    response.lineBarSpots != null) {
                  final spot = response.lineBarSpots!.first;
                  final date = DateTime.fromMillisecondsSinceEpoch(spot.x.toInt());
                  final biologicalIndicatorValue = spot.y;
                  final biologicalIndicatorName = metric;

                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text(
                        DateFormat('yyyy-MM-dd   H:mm:ss').format(date),
                        style: auraFontFayrozi25
                      ),
                      content: Text(
                        "$biologicalIndicatorName: ${biologicalIndicatorValue.toStringAsFixed(2)}",
                        style: const TextStyle(fontSize: 20),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.red,
                            padding: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 20.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          child: const Text(
                            'OK',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }
              },
            ),


          ),
        ),
      ),
    );
  }
}
