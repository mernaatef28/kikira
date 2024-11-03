import 'package:flutter/material.dart';
import 'package:kikira/core/theming/colors.dart';

class dataCard extends StatelessWidget {
  final String date ;
  final String time ;
  final String SugerPersentage ;

  const dataCard(
      {
        required this.date,
        required this.time,
        required this.SugerPersentage
      }
      );

  @override
  Widget build(BuildContext context) {
    return Container(
  width: double.infinity,
  height: 200,
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("date:"  , style: TextStyle(fontSize: 20 ),),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 50.0),
            child: Text("time:"  , style: TextStyle(fontSize: 20 ),),
          ) ,
        ],
      ) ,
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 15.0),
            child: Text("$date"  , style: TextStyle(fontSize: 17  , color: colorManager.kikiBlue),),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: Text("$time"  , style: TextStyle(fontSize: 17  , color: colorManager.kikiBlue),),
          ) ,
        ],
      ) ,
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("Suger persentage:"  , style: TextStyle(fontSize: 30 ,fontWeight: FontWeight.bold),),
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Text("$SugerPersentage"  , style: TextStyle(fontSize: 30  , color: colorManager.kikiOrange),),
          ) ,
        ],
      )
    ],
  ),
);
  }
}
