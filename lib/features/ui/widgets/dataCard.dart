import 'package:flutter/material.dart';
import 'package:kikira/core/theming/colors.dart';
import 'package:kikira/core/theming/styles.dart';

class dataCard extends StatelessWidget {
  final String date ;
  final String time ;
  final String SugerPersentage ;
  final String averageTemprature ;
  final String bloodPressure ;


  const dataCard(
      {
        required this.date,
        required this.time,
        required this.SugerPersentage,
        required this.averageTemprature,
        required this.bloodPressure,

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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 12.0),
            child: Text("Suger persentage:"  , style: dataCardKikiblack20,),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: Text("$SugerPersentage"  , style: dataCardKikiBlue20,),
          ),


        ],
      ) ,     Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 12.0),
            child: Text("averageTemprature:"  , style: dataCardKikiblack20,),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: Text("$averageTemprature"  , style: dataCardKikiBlue20,),
          ) ,



        ],
      )  ,    Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 12.0),
            child: Text("bloodPressure:"  , style: dataCardKikiblack20,),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: Text("$bloodPressure"  , style: dataCardKikiBlue20,),
          ) ,



        ],
      ) ,
      Padding(
        padding: const EdgeInsets.only(left: 20 , right: 20),
        child: Divider(color: colorManager.kikiBlue),
      ),
    ],
  ),
);
  }
}
