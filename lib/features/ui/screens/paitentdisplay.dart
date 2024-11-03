import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:kikira/core/api/apiservice.dart';
import 'package:kikira/core/theming/colors.dart';
import 'package:kikira/features/ui/widgets/dataCard.dart';
import 'package:kikira/kiki_app.dart';

class Paitentdisplay extends StatefulWidget {
  const Paitentdisplay({super.key, required this.patientName});
  final String patientName;

  @override
  State<Paitentdisplay> createState() => _PaitentdisplayState();
}

class _PaitentdisplayState extends State<Paitentdisplay> {
  bool isLoading = true;
  List<PatientDto> patientData = [];
  final ApiService apiService = ApiService();

  @override
  void initState() {
    super.initState();
    fetchPatientData(widget.patientName);
  }

  // Fetch patient data by name
  void fetchPatientData(String name) async {
    try {
      var data = await apiService.getPatientDataByName(name);
      setState(() {
        patientData = data;
        isLoading = false; // Set loading to false after data is fetched
      });
    } catch (e) {
      print('Error fetching patient data: $e');
      setState(() {
        isLoading = false; // Ensure loading is set to false even on error
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorManager.kikiKohly,
        title: Text(widget.patientName, style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_outlined, color: Colors.white),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => kiki_Ra_app()));
          },
        ),
      ),
      body: Container(
        color: colorManager.kikiYellow,
        padding: EdgeInsets.all(16.0), // Add padding for better layout
        child: SingleChildScrollView( // Wrap in SingleChildScrollView for scrolling
          child: Column(
            children: [
              // Person image at the top
              Container(
                width: 300.0,
                height: 300,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/person.png"),
                    fit: BoxFit.fitWidth,
                  ),
                  borderRadius: BorderRadius.circular(25.0),
                ),
              ),
              SizedBox(height: 20), // Spacer between image and data cards
              // Display data cards based on fetched data
              if (isLoading) // Show loading indicator if data is being fetched
                Center(child: CircularProgressIndicator())
              else if (patientData.isNotEmpty)
                ...patientData.map((patient) {
                  return dataCard(
                    date: patient.date,
                    time: patient.time,
                    SugerPersentage: patient.sugarPercentage.toString(),
                  );
                }).toList()
              else
                Text('No patient data available.'),
              SizedBox(height: 20), // Spacer between data and chart
              Text("Sugar Percentage Chart", style: TextStyle(fontSize: 20)),
              // Add a chart that expands to fit available space
              SizedBox(
                height: 300, // Specify a height for the chart
                child: LineChartWidget(patientData: patientData),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

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
