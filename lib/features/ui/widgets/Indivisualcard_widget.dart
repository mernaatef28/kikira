import 'package:flutter/material.dart';
import 'package:kikira/core/theming/colors.dart';
import 'package:kikira/core/theming/styles.dart';

class IndivisualCard_Widget extends StatelessWidget {
  final String paitentName;
  final String addproductName;
  final String paitentId;
  final VoidCallback patientDisplayPush;
  final Function(String) deletePatient;

  IndivisualCard_Widget({
    required this.paitentId,
    required this.addproductName,
    required this.paitentName,
    required this.patientDisplayPush,
    required this.deletePatient,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Container(
        width: double.infinity,  // Set the width to take the full screen
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          color: Colors.white,
        ),
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 100.0,
              height: 100.0,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/person.png"),
                  fit: BoxFit.fitWidth,  // Ensures image fits nicely
                ),
                borderRadius: BorderRadius.circular(25.0),
              ),
            ),
            SizedBox(width: 20),  // Add some space between the image and text
            Expanded(  // Use Expanded to make sure the content takes the available space
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    paitentName,
                    style: aurabold25,
                  ),
                  Text(
                    paitentId,
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
                        color: colorManager.kikiYellow,
                        child: Icon(
                          Icons.contact_page_outlined,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 16),
                      MaterialButton(
                        onPressed: () => deletePatient(paitentId),  // Ensure this passes the patient ID
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        color: colorManager.kikiOrange,
                        child: Icon(
                          Icons.delete,
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
