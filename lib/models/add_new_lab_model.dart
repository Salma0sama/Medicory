class AddNewLabModel {
  final String name;
  final String googleMapsLink;
  final String address;
  final String ownerName;
  final String email;
  final String role;
  final List<String> userPhoneNumbers;
  final bool enabled;

  AddNewLabModel({
    required this.name,
    required this.googleMapsLink,
    required this.address,
    required this.ownerName,
    required this.email,
    required this.role,
    required this.userPhoneNumbers,
    required this.enabled,
  });

  factory AddNewLabModel.fromJson(Map<String, dynamic> json) {
    return AddNewLabModel(
      name: json['name'] as String,
      googleMapsLink: json['googleMapsLink'] as String,
      address: json['address'] as String,
      ownerName: json['ownerName'] as String,
      email: json['email'] as String,
      role: json['role'] as String,
      userPhoneNumbers:
          (json['userPhoneNumbers'] as List<dynamic>).cast<String>(),
      enabled: json['enabled'] as bool,
    );
  }
}
