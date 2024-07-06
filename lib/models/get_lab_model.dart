class GetLabModel {
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

  GetLabModel({
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

  factory GetLabModel.fromJson(Map<String, dynamic> json) {
    return GetLabModel(
      id: json['id'] as int,
      name: json['name'] as String,
      googleMapsLink: json['googleMapsLink'] as String,
      address: json['address'] as String,
      ownerName: json['ownerName'] as String,
      code: json['code'] as String,
      email: json['email'] as String,
      password: json['password'] ?? '',
      role: json['role'] as String,
      userPhoneNumbers:
          (json['userPhoneNumbers'] as List<dynamic>).cast<String>(),
      enabled: json['enabled'] as bool,
    );
  }
}
