class AddNewAdminModel {
  final String firstName;
  final String lastName;
  final String maritalStatus;
  final String gender;
  final String email;
  final String role;
  final List<String> phoneNumbers;
  final bool enabled;

  AddNewAdminModel({
    required this.firstName,
    required this.lastName,
    required this.maritalStatus,
    required this.gender,
    required this.email,
    required this.role,
    required this.phoneNumbers,
    required this.enabled,
  });

  factory AddNewAdminModel.fromJson(Map<String, dynamic> json) {
    return AddNewAdminModel(
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      maritalStatus: json['maritalStatus'] as String,
      gender: json['gender'] as String,
      email: json['email'] as String,
      role: json['role'] as String,
      phoneNumbers: (json['phoneNumbers'] as List<dynamic>).cast<String>(),
      enabled: json['enabled'] as bool,
    );
  }
}
