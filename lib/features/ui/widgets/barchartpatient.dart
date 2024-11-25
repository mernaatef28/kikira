import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:kikira/core/classes/patientdto.dart';
import 'package:kikira/core/theming/colors.dart';
import 'package:kikira/core/theming/styles.dart';

class BarChartPatient extends StatelessWidget {
  final List<PatientDto> patientData;
  final String metric;

  const BarChartPatient({
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
        dateA.year,
        dateA.month,
        dateA.day,
        timeA.hour,
        timeA.minute,
        timeA.second,
      );

      DateTime dateB = DateFormat('yyyy-MM-dd').parse(b.date);
      DateTime timeB = DateFormat('H:mm:ss').parse(b.time);
      DateTime dateTimeB = DateTime(
        dateB.year,
        dateB.month,
        dateB.day,
        timeB.hour,
        timeB.minute,
        timeB.second,
      );

      return dateTimeA.compareTo(dateTimeB);
    });

    List<BarChartGroupData> barGroups = [];

    // Populate barGroups based on the selected metric
    for (var patient in patientData) {
      DateTime date = DateFormat('yyyy-MM-dd').parse(patient.date);
      DateTime time = DateFormat('H:mm:ss').parse(patient.time);
      DateTime dateTime = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
        time.second,
      );

      double yValue;
      String biologicalIndicatorName;
      if (metric == 'sugarPercentage') {
        yValue = double.parse(patient.sugarPercentage.toString());
        biologicalIndicatorName = "Sugar Percentage";
      } else if (metric == 'averageTemperature') {
        yValue = double.parse(patient.averageTemprature.toString());
        biologicalIndicatorName = "Average Temperature";
      } else if (metric == 'bloodPressure') {
        yValue = double.parse(patient.bloodPressure.toString());
        biologicalIndicatorName = "Blood Pressure";
      } else {
        yValue = 0; // Fallback if an unknown metric is provided
        biologicalIndicatorName = "Unknown Metric";
      }

      barGroups.add(
        BarChartGroupData(
          x: dateTime.millisecondsSinceEpoch,
          barRods: [
            BarChartRodData(
              toY: yValue,
              color: colorManager.kikiFirozi,
              width: 10,
              borderRadius: BorderRadius.circular(4),
            ),
          ],
        ),
      );
    }

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
        child: BarChart(
          BarChartData(
            barGroups: barGroups,
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 40,
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
                    child:  Padding(
                      padding: const EdgeInsets.only(left: 8.0),
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
              border: const Border(
                top: BorderSide.none,
                right: BorderSide.none,
              ),
            ),
            gridData: FlGridData(
              show: true,
              drawVerticalLine: false,
              drawHorizontalLine: true,
            ),
            barTouchData: BarTouchData(
              touchTooltipData: BarTouchTooltipData(

                tooltipPadding: const EdgeInsets.all(0),
                tooltipMargin: 0,
                getTooltipItem: (group, groupIndex, rod, rodIndex) {
                  return null; // Disable built-in tooltips
                },
              ),
              touchCallback: (event, response) {
                if (event.isInterestedForInteractions &&
                    response != null &&
                    response.spot != null) {
                  final spot = response.spot!;
                  final date = DateTime.fromMillisecondsSinceEpoch(spot.touchedBarGroup.x.toInt());
                  final biologicalIndicatorValue = spot.touchedRodData.toY;
                  final biologicalIndicatorName = metric; // Use metric as the name

                  // Show an alert dialog with the selected data
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text(
                        DateFormat('yyyy-MM-dd   H:mm:ss').format(date),
                        style: auraFontFayrozi25,
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
                            padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          child: Text(
                            'OK',
                            style: TextStyle(
                              color:AppColors.lightBlue, // Good contrast for the button text
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
