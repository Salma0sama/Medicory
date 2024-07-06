class RelativePhoneNumber {
  final int id;
  final String phone;
  final String relation;

  RelativePhoneNumber({
    required this.id,
    required this.phone,
    required this.relation,
  });

  factory RelativePhoneNumber.fromJson(Map<String, dynamic> json) {
    return RelativePhoneNumber(
      id: json['id'],
      phone: json['phone'],
      relation: json['relation'],
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

class UserMedicalInfo {
  final String ownerName;
  final String bloodType;
  final List<String> chronicDiseases;
  final List<String> allergies;
  final List<String> surgeries;
  final List<String> medicines;
  final List<RelativePhoneNumber> relativePhoneNumbers;

  UserMedicalInfo({
    required this.ownerName,
    required this.bloodType,
    required this.chronicDiseases,
    required this.allergies,
    required this.surgeries,
    required this.medicines,
    required this.relativePhoneNumbers,
  });

  factory UserMedicalInfo.fromJson(Map<String, dynamic> json) {
    var chronicDiseasesFromJson = json['chronicDiseases'].cast<String>();
    var allergiesFromJson = json['allergies'].cast<String>();
    var surgeriesFromJson = json['surgeries'].cast<String>();
    var medicinesFromJson = json['medicines'].cast<String>();
    var relativePhoneNumbersFromJson = (json['relativePhoneNumbers'] as List)
        .map((item) => RelativePhoneNumber.fromJson(item))
        .toList();

    return UserMedicalInfo(
      ownerName: json['ownerName'],
      bloodType: json['bloodType'],
      chronicDiseases: chronicDiseasesFromJson,
      allergies: allergiesFromJson,
      surgeries: surgeriesFromJson,
      medicines: medicinesFromJson,
      relativePhoneNumbers: relativePhoneNumbersFromJson,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ownerName': ownerName,
      'bloodType': bloodType,
      'chronicDiseases': chronicDiseases,
      'allergies': allergies,
      'surgeries': surgeries,
      'medicines': medicines,
      'relativePhoneNumbers': relativePhoneNumbers
          .map((relativePhoneNumber) => relativePhoneNumber.toJson())
          .toList(),
    };
  }
}
