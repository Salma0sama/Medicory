class AddNewClinicModel {
  final String name;
  final String googleMapsLink;
  final String address;
  final String ownerName;
  final String specialization;
  final String email;
  final String role;
  final List<String> userPhoneNumbers;
  final bool enabled;

  AddNewClinicModel({
    required this.name,
    required this.googleMapsLink,
    required this.address,
    required this.ownerName,
    required this.specialization,
    required this.email,
    required this.role,
    required this.userPhoneNumbers,
    required this.enabled,
  });

  factory AddNewClinicModel.fromJson(Map<String, dynamic> json) {
    return AddNewClinicModel(
      name: json['name'] as String,
      googleMapsLink: json['googleMapsLink'] as String,
      address: json['address'] as String,
      ownerName: json['ownerName'] as String,
      specialization: json['specialization'] as String,
      email: json['email'] as String,
      role: json['role'] as String,
      userPhoneNumbers:
          (json['userPhoneNumbers'] as List<dynamic>).cast<String>(),
      enabled: json['enabled'] as bool,
    );
  }
}
