class GetDoctorModel {
  final int id;
  String firstName;
  String middleName;
  String lastName;
  final String specialization;
  final String licenceNumber;
  final String nationalId;
  final String maritalStatus;
  final String gender;
  final String code;
  final String email;
  final String password;
  final String role;
  final List<String> userPhoneNumbers;
  bool enabled;

  GetDoctorModel({
    required this.id,
    required this.firstName,
    required this.middleName,
    required this.lastName,
    required this.specialization,
    required this.licenceNumber,
    required this.nationalId,
    required this.maritalStatus,
    required this.gender,
    required this.code,
    required this.email,
    required this.password,
    required this.role,
    required this.userPhoneNumbers,
    required this.enabled,
  });

  factory GetDoctorModel.fromJson(Map<String, dynamic> json) {
    return GetDoctorModel(
      id: json['id'] as int,
      firstName: json['firstName'] as String,
      middleName: json['middleName'] as String,
      lastName: json['lastName'] as String,
      specialization: json['specialization'] as String,
      licenceNumber: json['licenceNumber'] as String,
      nationalId: json['nationalId'] as String,
      maritalStatus: json['maritalStatus'] as String,
      gender: json['gender'] as String,
      code: json['code'] as String,
      email: json['email'] as String,
      password: json['password'] ?? '',
      role: json['role'] as String,
      userPhoneNumbers: List<String>.from(json['userPhoneNumbers'] as List),
      enabled: json['enabled'] as bool,
    );
  }
}
