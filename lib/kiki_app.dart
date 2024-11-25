import 'package:flutter/material.dart';
import 'package:kikira/core/api/apiservicetoken.dart';
import 'package:kikira/core/theming/colors.dart';
import 'package:kikira/core/theming/styles.dart';
import 'package:kikira/features/ui/screens/display_all_screen.dart';
import 'package:kikira/features/ui/screens/filterbydate.dart';
import 'package:kikira/features/ui/screens/getcriticaltoday.dart';
import 'package:kikira/features/ui/screens/indivisual_search.dart';
import 'package:kikira/features/ui/widgets/biologicalindicatorcard.dart';
import 'package:kikira/features/ui/widgets/btn.dart';
import 'package:kikira/features/ui/widgets/chartallpaitentlinear.dart';
import 'package:kikira/features/ui/widgets/chartallpeitient.dart';
import 'package:kikira/features/ui/widgets/moreInformation.dart';

class KikiRaApp extends StatefulWidget {
  @override
  State<KikiRaApp> createState() => _KikiRaAppState();
}

class _KikiRaAppState extends State<KikiRaApp> {
  String? username;
  String? hospitalName;
  final ApiService apiService = ApiService();

  @override
  void initState() {
    super.initState();
    fetchUserDetails();
  }

  Future<void> fetchUserDetails() async {
    String? fetchedUsername = await apiService.getsavedUserName();
    String? fetchedHospitalName = await apiService.getsavedUserHospitalName();


    setState(() {
      username = fetchedUsername;
      hospitalName = fetchedHospitalName;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: colorManager.kikiGray,
      leading: IconButton(onPressed: (){}, icon: Icon(Icons.menu , color: firozi, size: 40,)),
      actions: [
        IconButton(
          icon: Icon(Icons.inbox_outlined, color: colorManager.kikiFirozi  , size: 30),
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text("Patients Chart", style: TextStyle(fontSize: 20)),
                  content: CriticalToday(),
                );
              },
            );
          },
        ),
      ],),
      body: Container(
        color: colorManager.kikiGray,
        child: ListView(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 20,
                            ),
                            Text('Hi, ${username}!',
                                style: kikihomewelcomename),
                            SizedBox(height: 3),
                            Text(' ${hospitalName}', style: kikihospitalname),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ClipOval(
                          child: Image.asset(
                            "assets/images/hospital.png",
                            width: 90,
                            height: 90,
                            fit: BoxFit.cover,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text("Cases" , style: auraFontFayrozi25, textAlign: TextAlign.left,),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: IconButton(icon : Icon(Icons.info_outline) , color: colorManager.kikiFirozi,onPressed: (){showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return NotificationPage();
                        },
                      );},),
                    )
                  ],
                ),
                Container(
                  child: Wrap(
                    spacing: 8.0,
                    runSpacing: 3.0,
                    children: [

                      BiologicalIndicatorCard(
                        cardName: 'sugar percentage',
                        cardIconPath: "assets/images/sugar.png",
                        targetPage: DisplayAllScreen(hospitalName: hospitalName!, BioIndicatorFilter: 'Sugar Percentage', ),
                      ),
                      BiologicalIndicatorCard(
                        cardName: 'blood Pressure',
                        cardIconPath: "assets/images/blood.png",
                        targetPage: DisplayAllScreen(hospitalName: hospitalName!, BioIndicatorFilter: 'Blood Pressure', ),
                      ),
                      BiologicalIndicatorCard(
                        cardName: 'average Temperature',
                        cardIconPath: "assets/images/temperature.png",
                        targetPage: DisplayAllScreen(hospitalName: hospitalName!, BioIndicatorFilter: 'Temperature', ),
                      ),
                      BiologicalIndicatorCard(
                        cardName: 'Health Condition',
                        cardIconPath: "assets/images/state.png",
                        targetPage: DisplayAllScreen(hospitalName: hospitalName!, BioIndicatorFilter: 'State', ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                width: 300, // Set an appropriate width
                height: 300,
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        // Shadow color with opacity
                        spreadRadius: 5,
                        // How much the shadow spreads
                        blurRadius: 7,
                        // How blurry the shadow is
                        offset: const Offset(0,
                            4), // Position of the shadow (horizontal, vertical)
                      ),
                    ],
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white),
                child: CriticalLineChart(),
              ),
            )
          ],
        ),
      ),
    );
  }
} /* */
