class GetHospitalModel {
  final int id;
  final String name;
  final String googleMapsLink;
  final String address;
  final String code;
  final String email;
  final String password;
  final String role;
  final List<String> userPhoneNumbers;
  final bool enabled;

  GetHospitalModel({
    required this.id,
    required this.name,
    required this.googleMapsLink,
    required this.address,
    required this.code,
    required this.email,
    required this.password,
    required this.role,
    required this.userPhoneNumbers,
    required this.enabled,
  });

  factory GetHospitalModel.fromJson(Map<String, dynamic> json) {
    return GetHospitalModel(
      id: json['id'] as int,
      name: json['name'] as String,
      googleMapsLink: json['googleMapsLink'] as String,
      address: json['address'] as String,
      code: json['code'] as String,
      email: json['email'] as String,
      password: json['password'] as String,
      role: json['role'] as String,
      userPhoneNumbers: List<String>.from(json['userPhoneNumbers'] as List),
      enabled: json['enabled'] as bool,
    );
  }
}
