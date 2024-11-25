class GetHospitals {
  final int id ;
  final String name ,
              address,
              city ,
              country ,
              imageURL ,
              hospitalImage ;
  GetHospitals({
    required this.id ,
    required this.name ,
    required this.address ,
    required this.city ,
    required this.country ,
    required this.hospitalImage ,
    required this.imageURL
});
  // Factory constructor to create a PatientDto from JSON
  factory GetHospitals.fromJson(Map<String, dynamic> json) {
  return GetHospitals(
      id: json['id']  ,
    name: json['name'] ,
    address: json['address'] ,
    city : json ['city'] ,
    country: json['counrty'] ,
    hospitalImage: json['hospitalImage'] ,
    imageURL: json['imageURL']

      ) ;
}
}



/*[
  {
    "id": 0,
    "name": "string",
    "address": "string",
    "city": "string",
    "country": "string",
    "imageURL": "string",
    "hospitalImage": "string"
  }
]*/