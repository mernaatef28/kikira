import 'package:kikira/core/classes/patientdtoname.dart';

class GetAllCritical {
  final int count;
  final String date;
  final List<PatientDtoName> patients ;

  GetAllCritical({
    required this.count,
    required this.date ,
    required this.patients
  });
  // Factory constructor to create a PatientDto from JSON
  factory GetAllCritical.fromJson(Map<String, dynamic> json) {

    return GetAllCritical(
      count: json['count'],
      date: json['date'],
      patients: (json['patients'] as List<dynamic>)
          .map((patientJson) => PatientDtoName.fromJson(patientJson))
          .toList(),// this should be a list
    );
  }
}
//[
//   {
//     "count": 11,
//     "date": "2024-10-23"
//   }
// ]id: 1053, name: John Doe, state: At Risk, hospitalId: 1}