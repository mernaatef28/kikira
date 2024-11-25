import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:kikira/core/theming/colors.dart';
import 'package:kikira/core/theming/indicator.dart';
import 'package:kikira/core/theming/styles.dart';

class PieChartSample2 extends StatefulWidget {
  final int atRiskCount;
  final int healthyCount;

  const PieChartSample2({
    super.key,
    required this.atRiskCount,
    required this.healthyCount,
  });

  @override
  State<StatefulWidget> createState() => PieChart2State();
}

class PieChart2State extends State<PieChartSample2> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    int totalCount = widget.atRiskCount + widget.healthyCount;
    double atRiskPercentage =
    totalCount == 0 ? 0 : (widget.atRiskCount / totalCount) * 100;
    double healthyPercentage =
    totalCount == 0 ? 0 : (widget.healthyCount / totalCount) * 100;

    return AlertDialog(
      title: Text(
        "Patients Chart",
        style: auraFontFayrozi25,
      ),
      content: AspectRatio(
        aspectRatio: 1.3,
        child: Row(
          children: <Widget>[
            const SizedBox(height: 18),
            Expanded(
              child: AspectRatio(
                aspectRatio: 1,
                child: PieChart(
                  PieChartData(
                    pieTouchData: PieTouchData(
                      touchCallback: (FlTouchEvent event, pieTouchResponse) {
                        setState(() {
                          if (!event.isInterestedForInteractions ||
                              pieTouchResponse == null ||
                              pieTouchResponse.touchedSection == null) {
                            touchedIndex = -1;
                            return;
                          }
                          touchedIndex = pieTouchResponse
                              .touchedSection!.touchedSectionIndex;
                        });
                      },
                    ),
                    borderData: FlBorderData(show: false),
                    sectionsSpace: 0,
                    centerSpaceRadius: 40,
                    sections: showingSections(
                      atRiskPercentage,
                      healthyPercentage,
                    ),
                  ),
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Indicator(
                  color: Colors.red,
                  text: 'At Risk',
                  isSquare: true,
                ),
                const SizedBox(height: 4),
                const Indicator(
                  color: Colors.green,
                  text: 'Healthy',
                  isSquare: true,
                ),
                const SizedBox(height: 18),
              ],
            ),
            const SizedBox(width: 28),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          style: TextButton.styleFrom(
            backgroundColor: Colors.red,
            padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
        side: const BorderSide(color: Colors.white, width: 2.0),
      ),
    );
  }

  List<PieChartSectionData> showingSections(
      double atRiskPercentage, double healthyPercentage) {
    return List.generate(2, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 25.0 : 16.0;
      final radius = isTouched ? 60.0 : 50.0;
      const shadows = [Shadow(color: Colors.black, blurRadius: 2)];

      switch (i) {
        case 0:
          return PieChartSectionData(
            color: Colors.red,
            value: atRiskPercentage,
            title: '${atRiskPercentage.toStringAsFixed(1)}%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: shadows,
            ),
          );
        case 1:
          return PieChartSectionData(
            color: Colors.green,
            value: healthyPercentage,
            title: '${healthyPercentage.toStringAsFixed(1)}%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: shadows,
            ),
          );
        default:
          throw Error();
      }
    });
  }
}
