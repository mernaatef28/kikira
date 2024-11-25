import 'package:kikira/core/classes/lastbiologicalindicator.dart';

class PatientDtoName {
  final int id;
  final String name;
  final LastBiologicalIndicator lastBiologicalIndicator; // Change here
  final int hospitalId;

  PatientDtoName({
    required this.name,
    required this.lastBiologicalIndicator,
    required this.hospitalId,
    required this.id,
  });

  factory PatientDtoName.fromJson(Map<String, dynamic> json) {
    return PatientDtoName(
      name: json['name'],
      hospitalId: json['hospitalId'],
      id: json["id"],
      lastBiologicalIndicator: LastBiologicalIndicator.fromJson(
        json['lastBiologicalIndicator'], // Single object
      ),
    );
  }
}
