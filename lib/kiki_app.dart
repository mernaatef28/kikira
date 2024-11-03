import 'package:flutter/material.dart';
import 'package:kikira/core/theming/colors.dart';
import 'package:kikira/features/ui/screens/display_all_screen.dart';
import 'package:kikira/features/ui/screens/indivisual_search.dart';
import 'package:kikira/features/ui/widgets/btn.dart';

class kiki_Ra_app extends StatefulWidget {
  const kiki_Ra_app({super.key});

  @override
  State<kiki_Ra_app> createState() => _kiki_Ra_appState();
}

class _kiki_Ra_appState extends State<kiki_Ra_app> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Container(
        color: colorManager.kikiBlue,
        child: ListView(
            children:[ Center(
              child: Column(
                  children: [
                    Image.asset('assets/images/pinguin.png', height: 400),
                    Container(

                      decoration: BoxDecoration(color: colorManager.kikiYellow ,borderRadius: BorderRadius.only(topLeft: Radius.circular(25),topRight: Radius.circular(25))),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          SizedBox(height: 150,) ,
                          btnCal(text: "Display All", event: () {
                            Navigator.push(
                                context, MaterialPageRoute(builder: (context) => DisplayAllScreen()));

                          } , c: colorManager.kikiKohly , textColor: Colors.white)  ,
                          btnCal(text: "individual ", event: () {
                            Navigator.push(
                                context, MaterialPageRoute(builder: (context) => IndivisualSearch()));

                          } , c: colorManager.kikiOrange , textColor: Colors.white) ,
                          SizedBox(height: 250,)
                        ],
                      ),
                    )
                  ]),
            ),
            ]),
      ),
    );
  }
}