import 'package:flutter/material.dart';
import 'package:kikira/core/theming/styles.dart';

class BiologicalIndicatorCard extends StatelessWidget {
  final String cardName;
  final String cardIconPath; // Path for the image
  final Widget targetPage; // The page to navigate to

  const BiologicalIndicatorCard({
    super.key,
    required this.cardName,
    required this.cardIconPath,
    required this.targetPage,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => targetPage),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(

          width: 185,
          height: 110,
          decoration: BoxDecoration(
            boxShadow:  [
              BoxShadow(
                color: Colors.black.withOpacity(0.13), // Shadow color with opacity
                spreadRadius: 5, // How much the shadow spreads
                blurRadius: 7, // How blurry the shadow is
                offset: const Offset(0, 4), // Position of the shadow (horizontal, vertical)
              ),
            ],

            color: Colors.white70,
            borderRadius: BorderRadius.circular(25),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Text(
                    cardName,
                    style: dataCardKikiblack20, // Your custom style
                    maxLines: 2, // Limit to 2 lines
                    overflow: TextOverflow.ellipsis, // Handle overflow gracefully
                  ),
                ),
              ),
              const SizedBox(width: 10), // Spacing between image and text
              Padding(
                padding: const EdgeInsets.only(right: 8, top: 8, bottom: 8),
                child: Image.asset(
                  cardIconPath,
                  width: 50, // Adjust size
                  height: 50,
                  fit: BoxFit.contain,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
