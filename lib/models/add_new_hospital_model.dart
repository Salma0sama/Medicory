class AddNewHospitalModel {
  final String name;
  final String googleMapsLink;
  final String address;
  final String email;
  final String role;
  final List<String> userPhoneNumbers;
  final bool enabled;

  AddNewHospitalModel({
    required this.name,
    required this.googleMapsLink,
    required this.address,
    required this.email,
    required this.role,
    required this.userPhoneNumbers,
    required this.enabled,
  });

  factory AddNewHospitalModel.fromJson(Map<String, dynamic> json) {
    return AddNewHospitalModel(
      name: json['name'] as String,
      googleMapsLink: json['googleMapsLink'] as String,
      address: json['address'] as String,
      email: json['email'] as String,
      role: json['role'] as String,
      userPhoneNumbers:
          (json['userPhoneNumbers'] as List<dynamic>).cast<String>(),
      enabled: json['enabled'] as bool,
    );
  }
}
