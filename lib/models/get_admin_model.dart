class GetAdminModel {
  final int id;
  final String firstName;
  final String lastName;
  final String maritalStatus;
  final String gender;
  final String code;
  final String email;
  final String password;
  final String role;
  final List<String> userPhoneNumbers;
  final bool enabled;

  GetAdminModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.maritalStatus,
    required this.gender,
    required this.code,
    required this.email,
    required this.password,
    required this.role,
    required this.userPhoneNumbers,
    required this.enabled,
  });

  factory GetAdminModel.fromJson(Map<String, dynamic> json) {
    return GetAdminModel(
      id: json['id'] as int,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      maritalStatus: json['maritalStatus'] as String,
      gender: json['gender'] as String,
      code: json['code'] as String,
      email: json['email'] as String,
      password: json['password'] as String,
      role: json['role'] as String,
      userPhoneNumbers: (json['userPhoneNumbers'] as List<dynamic>)
          .map((phone) => phone.toString())
          .toList(),
      enabled: json['enabled'] as bool,
    );
  }
}
