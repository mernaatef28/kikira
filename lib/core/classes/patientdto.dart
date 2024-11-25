// Model class for PatientDto
class PatientDto {
  final int id ;
  final dynamic sugarPercentage;
  final String time;
  final String date;
  final dynamic healthConditionScore;
  final String healthCondition;
  final dynamic bloodPressure ;
  final dynamic averageTemprature ;


  PatientDto( {
    required this.id,
    required this.sugarPercentage,
    required this.time,
    required this.date,
    required this.healthConditionScore,
    required this.healthCondition ,
    required this.averageTemprature ,
    required this.bloodPressure
  });

  // Factory constructor to create a PatientDto from JSON
  factory PatientDto.fromJson(Map<String, dynamic> json) {
    return PatientDto(
      id: json["id"],
      sugarPercentage: json['sugarPercentage'],
      time: json['time'],
      date: json['date'],
      healthConditionScore: json['healthConditionScore'],
      healthCondition: json['healthCondition'],
      averageTemprature: json["averageTemprature"],
      bloodPressure: json["bloodPressure"],

    );
  }

  @override
  String toString() {
    return 'Date: $date, Time: $time, Sugar: $sugarPercentage, Health Score: $healthConditionScore , healthCondition : $healthCondition , averageTemprature : $averageTemprature , bloodPressure : $bloodPressure' ;
  }
}
//[
//   {
//     "id": 0,
//     "healthConditionScore": 0,
//     "healthCondition": "string",
//     "sugarPercentage": 0,
//     "bloodPressure": 0,
//     "averageTemprature": 0,
//     "date": "2024-11-16",
//     "time": "string"
//   }
// ]