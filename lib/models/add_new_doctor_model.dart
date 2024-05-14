class AddNewDoctorModel {
  final String firstName;
  final String middleName;
  final String lastName;
  final String specialization;
  final String licenseNumber;
  // final int nationalId;
  final String nationalId;
  final String maritalStatus;
  final String gender;
  final String email;
  final String role;
  final List<String> userPhoneNumbers;
  final bool enabled;

  AddNewDoctorModel({
    required this.firstName,
    required this.middleName,
    required this.lastName,
    required this.specialization,
    required this.licenseNumber,
    required this.nationalId,
    required this.maritalStatus,
    required this.gender,
    required this.email,
    required this.role,
    required this.userPhoneNumbers,
    required this.enabled,
  });

  factory AddNewDoctorModel.fromJson(Map<String, dynamic> json) {
    return AddNewDoctorModel(
      firstName: json['firstName'] as String,
      middleName: json['middleName'] as String,
      lastName: json['lastName'] as String,
      specialization: json['specialization'] as String,
      licenseNumber: json['licenceNumber'] as String,
      // nationalId: json['nationalId'] as int,
      nationalId: json['nationalId'] as String,
      maritalStatus: json['maritalStatus'] as String,
      gender: json['gender'] as String,
      email: json['email'] as String,
      role: json['role'] as String,
      userPhoneNumbers:
          (json['userPhoneNumbers'] as List<dynamic>).cast<String>(),
      enabled: json['enabled'] as bool,
    );
  }
}
