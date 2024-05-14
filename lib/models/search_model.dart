class GetOwnerSearch {
  final int id;
  final String fullName;
  final bool isEnabled;

  const GetOwnerSearch({
    required this.id,
    required this.fullName,
    required this.isEnabled,
  });

  factory GetOwnerSearch.fromJson(json) {
    return GetOwnerSearch(
      id: json['id'] as int,
      fullName: json['fullName'] as String? ?? '',
      isEnabled: json['isEnabled'] as bool,
    );
  }
}

class GetClinicSearch {
  final int clinicId;
  final String clinicName;
  final bool enabled;

  GetClinicSearch({
    required this.clinicId,
    required this.clinicName,
    required this.enabled,
  });

  factory GetClinicSearch.fromJson(json) {
    return GetClinicSearch(
      clinicId: json['clinicId'] as int,
      clinicName: json['clinicName'] as String? ?? '',
      enabled: json['enabled'] as bool,
    );
  }
}

class GetAdminSearch {
  final int id;
  final String adminName;
  final bool enabled;

  GetAdminSearch({
    required this.id,
    required this.adminName,
    required this.enabled,
  });

  factory GetAdminSearch.fromJson(json) {
    return GetAdminSearch(
      id: json['id'] as int,
      adminName: json['adminName'] as String? ?? '',
      enabled: json['enabled'] as bool,
    );
  }
}

class GetPharmacySearch {
  final int pharmacyId;
  final String pharmacyName;
  final bool enabled;

  GetPharmacySearch({
    required this.pharmacyId,
    required this.pharmacyName,
    required this.enabled,
  });

  factory GetPharmacySearch.fromJson(json) {
    return GetPharmacySearch(
      pharmacyId: json['pharmacyId'] as int,
      pharmacyName: json['pharmacyName'] as String? ?? '',
      enabled: json['enabled'] as bool,
    );
  }
}

class GetDoctorSearch {
  final int doctorId;
  final String doctorName;
  final bool enabled;

  GetDoctorSearch({
    required this.doctorId,
    required this.doctorName,
    required this.enabled,
  });

  factory GetDoctorSearch.fromJson(json) {
    return GetDoctorSearch(
      doctorId: json['doctorId'] as int,
      doctorName: json['doctorName'] as String? ?? '',
      enabled: json['enabled'] as bool,
    );
  }
}

class GetHospitalSearch {
  final int hospitalId;
  final String hospitalName;
  final bool enabled;

  GetHospitalSearch({
    required this.hospitalId,
    required this.hospitalName,
    required this.enabled,
  });

  factory GetHospitalSearch.fromJson(json) {
    return GetHospitalSearch(
      hospitalId: json['hospitalId'] as int,
      hospitalName: json['hospitalName'] as String? ?? '',
      enabled: json['enabled'] as bool,
    );
  }
}

class GetLabSearch {
  final int labId;
  final String labName;
  final bool enabled;

  GetLabSearch({
    required this.labId,
    required this.labName,
    required this.enabled,
  });

  factory GetLabSearch.fromJson(json) {
    return GetLabSearch(
      labId: json['labId'] as int,
      labName: json['labName'] as String? ?? '',
      enabled: json['enabled'] as bool,
    );
  }
}
