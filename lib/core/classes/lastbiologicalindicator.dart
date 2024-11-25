class LastBiologicalIndicator{
  final String healthCondition ;
  final dynamic sugarPercentage ,
                bloodPressure ,
                averageTemprature ;
  LastBiologicalIndicator({
    required this.healthCondition ,
    required this.sugarPercentage ,
    required this.bloodPressure ,
    required this.averageTemprature
}) ;
  factory LastBiologicalIndicator.fromJson(Map<String, dynamic> json) {
    return LastBiologicalIndicator(
      healthCondition: json['healthCondition'],
      sugarPercentage: json['sugarPercentage'],
      bloodPressure: json['bloodPressure'], // Fix here
      averageTemprature: json['averageTemprature'],
    );
  }



}




/*
* "lastBiologicalIndicator": {
      "healthCondition": "string",
      "sugarPercentage": 0,
      "bloodPressure": 0,
      "averageTemprature": 0
    }*/