import 'package:flutter/material.dart';
import 'package:kikira/core/api/apiservicetoken.dart';
import 'package:kikira/core/api/geminiservice.dart';
import 'package:kikira/core/classes/patientdto.dart';
import 'package:kikira/core/theming/colors.dart';
import 'package:kikira/core/theming/styles.dart';
import 'package:kikira/features/ui/widgets/barchartpatient.dart';
import 'package:kikira/features/ui/widgets/chartpatient.dart';


class Paitentdisplay extends StatefulWidget {
  final String patientName;
  late String hospitalName;
  final bool scrollToChart;

  Paitentdisplay(
      {super.key,
        required this.patientName,
        this.scrollToChart = false,
        this.hospitalName = 'unknown'});

  @override
  State<Paitentdisplay> createState() => _PaitentdisplayState();
}

class _PaitentdisplayState extends State<Paitentdisplay> {
  String selectedMetric = 'sugarPercentage';
  String selectedChart = 'lineChart'; // Default chart type
  bool isLoading = true;
  List<PatientDto> patientData = [];
  String geminiResponse = '';
  final ApiService apiService = ApiService();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    fetchPatientData(widget.patientName);
  }

  void fetchPatientData(String name) async {
    try {
      var data = await apiService.getPatientDataByName(name);
      String requestText = data.join(" ");
     // String? geminiResponse = await GeminiService().getResponse(requestText);

      setState(() {
        patientData = data;
        isLoading = false;
       // this.geminiResponse = geminiResponse ?? '';
      });

      if (widget.scrollToChart) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _scrollToChartSection();
        });
      }
    } catch (e) {
      print('Error fetching patient data: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  void _scrollToChartSection() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: Duration(seconds: 2),
      curve: Curves.easeInOut,
    );
  }

  Widget _buildMetricButton(String metric, String assetPath) {
    final bool isSelected = selectedMetric == metric;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedMetric = metric;
        });
      },
      child: MouseRegion(
        onEnter: (_) {
          setState(() {
            selectedMetric = metric;
          });
        },
        child: Container(
          width: 150,
          height: 80,
          decoration: BoxDecoration(
            color: isSelected ? colorManager.kikiMint : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected ? colorManager.kikiFirozi : Colors.grey,
              width: 2,
            ),
            boxShadow: isSelected
                ? [
              BoxShadow(
                  color: Colors.teal.withOpacity(0.6),
                  blurRadius: 5,
                  spreadRadius: 0.4)
            ]
                : [],
          ),
          child: Center(
            child: Image.asset(
              assetPath,
              width: 50,
              height: 50,
            ),
          ),
        ),
      ),
    );
  }


  Widget _buildChartButton(String chartType, String assetPath) {
    final bool isSelected = selectedChart == chartType;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedChart = chartType;
        });
      },
      child: Container(
        width: 150,
        height: 80,
        decoration: BoxDecoration(
          color: isSelected ? colorManager.kikiMint : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? colorManager.kikiFirozi : Colors.grey,
            width: 2,
          ),
        ),
        child: Center(
          child: Image.asset(
            assetPath,
            width: 70,
            height: 70,
            color: isSelected? Colors.white : null ,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorManager.kikiFirozi,
        title: Text(widget.patientName, style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_outlined, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.info_outline, color: colorManager.kikiGray),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text("Patients Chart", style: TextStyle(fontSize: 20)),
                    content: Text(geminiResponse, style: TextStyle(fontSize: 16)),
                  );
                },
              );
            },
          ),
        ],
      ),
      body: Container(
        height: double.infinity,
        color: colorManager.kikiGray,
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  ClipOval(
                    child: Container(
                      width: 150.0,
                      height: 150,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("assets/images/12.png"),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 30.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.patientName, style: TextStyle(fontSize: 20)),
                        Text(widget.hospitalName, style: TextStyle(fontSize: 16)),
                      ],
                    ),
                  ),
                ],
              ),
              Text("Biological Indicator" ,style: auraFontFayrozi25,) ,
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildMetricButton('sugarPercentage', 'assets/images/sugar.png'),
                    SizedBox(width: 10),
                    _buildMetricButton('bloodPressure', 'assets/images/blood.png'),
                    SizedBox(width: 10),
                    _buildMetricButton('averageTemperature', 'assets/images/temperature.png'),
                    SizedBox(width: 10),

                  ],
                ),
              ),
              Text("Chart Type" , style: auraFontFayrozi25,) ,
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(

                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Padding(
                      padding: const EdgeInsets.only(top: 8.0 , right: 8),
                      child: _buildChartButton('lineChart', 'assets/images/6.png'),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: _buildChartButton('barChart', 'assets/images/5.png'),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Text("$selectedMetric - $selectedChart", style: TextStyle(fontSize: 20)),
              SizedBox(
                height: 350,
                child: selectedChart == 'lineChart'
                    ? LineChartWidget(
                  patientData: patientData,
                  metric: selectedMetric,
                )
                    : BarChartPatient(
                  patientData: patientData,
                  metric: selectedMetric,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/*Text("Average Temperature Chart", style: TextStyle(fontSize: 20)),
              SizedBox(
                height: 300,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: LineChartWidget(patientData: patientData, metric: 'averageTemperature',),
                ),
              ),
              SizedBox(height: 20),
              Text("Blood Pressure Chart", style: TextStyle(fontSize: 20)),
              SizedBox(
                height: 300,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: LineChartWidget(patientData: patientData, metric: 'bloodPressure',),
                ),
              ),*/
