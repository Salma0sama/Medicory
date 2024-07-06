class GetPharmacyModel {
  final int id;
  String name;
  final String googleMapsLink;
  final String address;
  final String ownerName;
  final String code;
  final String email;
  final String password;
  final String role;
  final List<String> userPhoneNumbers;
  bool enabled;

  GetPharmacyModel({
    required this.id,
    required this.name,
    required this.googleMapsLink,
    required this.address,
    required this.ownerName,
    required this.code,
    required this.email,
    required this.password,
    required this.role,
    required this.userPhoneNumbers,
    required this.enabled,
  });

  factory GetPharmacyModel.fromJson(Map<String, dynamic> json) {
    return GetPharmacyModel(
      id: json['id'] as int,
      name: json['name'] as String,
      googleMapsLink: json['googleMapsLink'] as String,
      address: json['address'] as String,
      ownerName: json['ownerName'] as String,
      code: json['code'] as String,
      email: json['email'] as String,
      password: json['password'] ?? '',
      role: json['role'] as String,
      userPhoneNumbers: List<String>.from(json['userPhoneNumbers'] as List),
      enabled: json['enabled'] as bool,
    );
  }
}
