import 'package:flutter/material.dart';
import 'package:kikira/core/theming/colors.dart';
import 'package:kikira/core/theming/styles.dart';

class NotificationPage extends StatelessWidget {



  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("what are Cases ?" , style: auraFontFayrozi25,
      ),
      content: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: Text(
          "we have 3 mean Biological Indicator , so you doctor can review your patients by them and happily reach them   ",

        ),
      ),
      backgroundColor: Colors.white, // Softer background for a neutral look
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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0), // More rounded corners for a modern look
        side: BorderSide(
          color: AppColors.tealBlue, // Border to complement the teal blue theme
          width: 2.0,
        ),
      ),
    );
  }
}
