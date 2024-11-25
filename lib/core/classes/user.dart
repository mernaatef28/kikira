class User {
  final String email;
  final String username;
  final String hospitalName;
  final String token;
  final String role ;

  User({
    required this.email,
    required this.username,
    required this.hospitalName,
    required this.token,
    required this.role
  });

  // Factory method to create an instance of User from a JSON object
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      email: json['email'],
      username: json['username'],
      hospitalName: json['hospitalName'],
      token: json['token'],
      role: json['role']
    );
  }

  // Method to convert a User instance into a JSON object
  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'username': username,
      'hospitalName': hospitalName,
      'token': token,
      'role':role
    };
  }
}
/*[
  {
    "id": 1,
    "name": "Central Hospital",
    "address": "123 Main St",
    "city": "New York",
    "country": "USA"
  }
]*/
//"role": "User"