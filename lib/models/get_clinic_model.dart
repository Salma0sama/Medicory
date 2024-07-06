class GetClinicModel {
  final int id;
  String name;
  final String googleMapsLink;
  final String address;
  final String ownerName;
  final String specialization;
  final String code;
  final String email;
  final String password;
  final String role;
  final List<String> userPhoneNumbers;
  bool enabled;

  GetClinicModel({
    required this.id,
    required this.name,
    required this.googleMapsLink,
    required this.address,
    required this.ownerName,
    required this.specialization,
    required this.code,
    required this.email,
    required this.password,
    required this.role,
    required this.userPhoneNumbers,
    required this.enabled,
  });

  factory GetClinicModel.fromJson(Map<String, dynamic> json) {
    return GetClinicModel(
      id: json['id'] as int,
      name: json['name'] as String,
      googleMapsLink: json['googleMapsLink'] as String,
      address: json['address'] as String,
      ownerName: json['ownerName'] as String,
      specialization: json['specialization'] as String,
      code: json['code'] as String,
      email: json['email'] as String,
      password: json['password'] ?? '',
      role: json['role'] as String,
      userPhoneNumbers:
          (json['userPhoneNumbers'] as List<dynamic>).cast<String>(),
      enabled: json['enabled'] as bool,
    );
  }

  // factory GetClinicModel.fromJson(Map<String, dynamic> json) {
  //   return GetClinicModel(
  //     id: json['id'] as int,
  //     name: json['name'] as String? ?? "", // Handle potential null value
  //     googleMapsLink: json['googleMapsLink'] as String? ??
  //         "", // Handle potential null value
  //     address: json['address'] as String? ?? "", // Handle potential null value
  //     ownerName:
  //         json['ownerName'] as String? ?? "", // Handle potential null value
  //     specialization: json['specialization'] as String? ??
  //         "", // Handle potential null value
  //     code: json['code'] as String? ?? "", // Handle potential null value
  //     email: json['email'] as String? ?? "", // Handle potential null value
  //     password:
  //         json['password'] as String? ?? "", // Handle potential null value
  //     role: json['role'] as String? ?? "", // Handle potential null value
  //     userPhoneNumbers: (json['userPhoneNumbers'] as List<dynamic>?)
  //             ?.map((phone) =>
  //                 phone.toString()) // Convert phone numbers to strings
  //             .toList() ??
  //         [], // Handle potential null value
  //     enabled: json['enabled'] as bool? ?? false, // Handle potential null value
  //   );
  // }
}
