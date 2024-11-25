import 'package:flutter/material.dart';
import 'package:kikira/core/theming/colors.dart';
import 'package:kikira/core/theming/colors.dart';
import 'package:kikira/core/theming/styles.dart';

class IndivisualCard_Widget extends StatelessWidget {
  final String paitentName;
  final String addproductName;
  final String paitentId;
  final VoidCallback patientDisplayPush;
  final VoidCallback goToChart;
  final Color cardColor;
  final String hospitalName;

  IndivisualCard_Widget({
    required this.paitentId,
    required this.addproductName,
    required this.paitentName,
    required this.patientDisplayPush,
    required this.goToChart,
    required this.cardColor,
    required this.hospitalName ,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          color: cardColor,
        ),
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 100.0,
              height: 100.0,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/12.png"),
                  fit: BoxFit.fitWidth,
                ),
                borderRadius: BorderRadius.circular(25.0),
              ),
            ),
            SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    paitentName,
                    style: aurabold25,
                  ),
                  /*Text(
                    paitentId,
                    style: auraFontboldgray15,
                  ),*/
                  Text(
                    hospitalName,
                    style: auraFontboldgray15,
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      MaterialButton(
                        onPressed: patientDisplayPush,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        color: colorManager.kikiFirozi,
                        child: Icon(
                          Icons.contact_page_outlined,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 16),
                      MaterialButton(
                        onPressed: goToChart,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        color: colorManager.kikiMint,
                        child: Icon(
                          Icons.show_chart,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

