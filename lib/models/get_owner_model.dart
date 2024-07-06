class GetOwnerModel {
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
  final List<RelativePhoneNumber> relativePhoneNumbers;
  final UserDetail user;

  const GetOwnerModel({
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

  factory GetOwnerModel.fromJson(Map<String, dynamic> json) {
    return GetOwnerModel(
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
          .map((dynamic item) => RelativePhoneNumber.fromJson(item))
          .toList(),
      user: UserDetail.fromJson(json['user'] as Map<String, dynamic>),
    );
  }
}

class RelativePhoneNumber {
  final int id;
  final String phone;
  final String relation;

  RelativePhoneNumber(
      {required this.id, required this.phone, required this.relation});

  factory RelativePhoneNumber.fromJson(Map<String, dynamic> json) {
    return RelativePhoneNumber(
      id: json['id'] as int,
      phone: json['phone'] as String,
      relation: json['relation'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'phone': phone,
      'relation': relation,
    };
  }
}

class UserDetail {
  final String code;
  final String email;
  final String? password;
  final String role;
  final List<UserPhoneNumber> userPhoneNumbers;
  final bool enabled;

  UserDetail({
    required this.code,
    required this.email,
    required this.password,
    required this.role,
    required this.userPhoneNumbers,
    required this.enabled,
  });

  factory UserDetail.fromJson(Map<String, dynamic> json) {
    return UserDetail(
      code: json['code'] as String,
      email: json['email'] as String,
      password: json['password'] ?? '',
      role: json['role'] as String,
      userPhoneNumbers: (json['userPhoneNumbers'] as List)
          .map((dynamic item) => UserPhoneNumber.fromJson(item))
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

class UserPhoneNumber {
  final int id;
  final String phone;

  UserPhoneNumber({required this.id, required this.phone});

  factory UserPhoneNumber.fromJson(Map<String, dynamic> json) {
    return UserPhoneNumber(
      id: json['id'] as int,
      phone: json['phone'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'phone': phone,
    };
  }
}
