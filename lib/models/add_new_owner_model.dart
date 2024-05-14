class AddNewOwnerModel {
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

  const AddNewOwnerModel({
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

  factory AddNewOwnerModel.fromJson(Map<String, dynamic> json) {
    return AddNewOwnerModel(
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
  final String phone;
  final String relation;

  RelativePhoneNumber({required this.phone, required this.relation});

  factory RelativePhoneNumber.fromJson(Map<String, dynamic> json) {
    return RelativePhoneNumber(
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

class UserDetail {
  final String email;
  final String role;
  final List<UserPhoneNumber> userPhoneNumbers;
  final bool enabled;

  UserDetail({
    required this.email,
    required this.role,
    required this.userPhoneNumbers,
    required this.enabled,
  });

  factory UserDetail.fromJson(Map<String, dynamic> json) {
    return UserDetail(
      email: json['email'] as String,
      role: json['role'] as String,
      userPhoneNumbers: (json['userPhoneNumbers'] as List)
          .map((dynamic item) => UserPhoneNumber.fromJson(item))
          .toList(),
      enabled: json['enabled'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'role': role,
      'userPhoneNumbers': userPhoneNumbers.map((e) => e.toJson()).toList(),
      'enabled': enabled,
    };
  }
}

class UserPhoneNumber {
  final String phone;

  UserPhoneNumber({required this.phone});

  factory UserPhoneNumber.fromJson(Map<String, dynamic> json) {
    return UserPhoneNumber(
      phone: json['phone'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'phone': phone,
    };
  }
}
