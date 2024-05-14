class EditOwnerModel {
  final int id;
  final String firstName;
  final String middleName;
  final String lastName;
  final String gender;
  final String dateOfBirth;
  final String address;
  final String bloodType;
  final int nationalId;
  final String maritalStatus;
  final String job;
  final List<RelativePhoneNumbers> relativePhoneNumbers;
  final UserDetails user;

  const EditOwnerModel({
    required this.id,
    required this.firstName,
    required this.middleName,
    required this.lastName,
    required this.gender,
    required this.dateOfBirth,
    required this.address,
    required this.bloodType,
    required this.nationalId,
    required this.maritalStatus,
    required this.job,
    required this.relativePhoneNumbers,
    required this.user,
  });

  factory EditOwnerModel.fromJson(Map<String, dynamic> json) {
    return EditOwnerModel(
      id: json['id'] as int,
      firstName: json['firstName'] as String,
      middleName: json['middleName'] as String,
      lastName: json['lastName'] as String,
      gender: json['gender'] as String,
      dateOfBirth: json['dateOfBirth'] as String,
      address: json['address'] as String,
      bloodType: json['bloodType'] as String,
      nationalId: json['nationalId'] as int,
      maritalStatus: json['maritalStatus'] as String,
      job: json['job'] as String,
      relativePhoneNumbers: (json['relativePhoneNumbers'] as List)
          .map((dynamic item) => RelativePhoneNumbers.fromJson(item))
          .toList(),
      user: UserDetails.fromJson(json['user'] as Map<String, dynamic>),
    );
  }
}

class RelativePhoneNumbers {
  final String phone;
  final String relation;

  RelativePhoneNumbers({required this.phone, required this.relation});

  factory RelativePhoneNumbers.fromJson(Map<String, dynamic> json) {
    return RelativePhoneNumbers(
      phone: json['phone'] as String,
      relation: json['relation'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'phone': phone,
      'relation': relation,
    };
  }
}

class UserDetails {
  final String code;
  final String email;
  final String password;
  final String role;
  final List<UserPhoneNumbers> userPhoneNumbers;
  final bool enabled;

  UserDetails({
    required this.code,
    required this.email,
    required this.password,
    required this.role,
    required this.userPhoneNumbers,
    required this.enabled,
  });

  factory UserDetails.fromJson(Map<String, dynamic> json) {
    return UserDetails(
      code: json['code'] as String,
      email: json['email'] as String,
      password: json['password'] as String,
      role: json['role'] as String,
      userPhoneNumbers: (json['userPhoneNumbers'] as List)
          .map((dynamic item) => UserPhoneNumbers.fromJson(item))
          .toList(),
      enabled: json['enabled'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'email': email,
      'password': password,
      'role': role,
      'userPhoneNumbers': userPhoneNumbers.map((e) => e.toJson()).toList(),
      'enabled': enabled,
    };
  }
}

class UserPhoneNumbers {
  final String phone;

  UserPhoneNumbers({required this.phone});

  factory UserPhoneNumbers.fromJson(Map<String, dynamic> json) {
    return UserPhoneNumbers(
      phone: json['phone'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'phone': phone,
    };
  }
}