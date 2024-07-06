class PrescriptionResponse {
  final int prescriptionId;
  final String? doctorName;
  final bool medicationStatus;
  final bool prescriptionStatus;
  final DateTime createdAt;
  final DateTime updatedAt;

  PrescriptionResponse({
    required this.prescriptionId,
    this.doctorName,
    required this.medicationStatus,
    required this.prescriptionStatus,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PrescriptionResponse.fromJson(Map<String, dynamic> json) {
    return PrescriptionResponse(
      prescriptionId: json['prescriptionId'] as int,
      doctorName: json['doctorName'] as String?,
      medicationStatus: json['medicationStatus'] as bool,
      prescriptionStatus: json['prescriptionStatus'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }
}

class GetPharmacyPrescriptionModel {
  final int prescriptionId;
  final String? doctorName;
  final DateTime createdAt;
  final PrescriptionDetailsModel prescriptionDetails;

  GetPharmacyPrescriptionModel({
    required this.prescriptionId,
    this.doctorName,
    required this.createdAt,
    required this.prescriptionDetails,
  });

  factory GetPharmacyPrescriptionModel.fromJson(Map<String, dynamic> json) {
    return GetPharmacyPrescriptionModel(
      prescriptionId: json['prescriptionId'] as int,
      doctorName: json['doctorName'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      prescriptionDetails: PrescriptionDetailsModel.fromJson(
        json['prescriptionDetails'] ?? {}, // Handle null or missing data
      ),
    );
  }
}

class Medication {
  final int id;
  final String name;
  final String dose;
  final int frequency;
  final String? sideEffects; // Nullable sideEffects
  final String tips;

  Medication({
    required this.id,
    required this.name,
    required this.dose,
    required this.frequency,
    this.sideEffects,
    required this.tips,
  });

  factory Medication.fromJson(Map<String, dynamic> json) {
    return Medication(
      id: json['id'],
      name: json['medicineName'],
      dose: json['dose'],
      frequency: json['frequency'],
      sideEffects: json['sideEffects'],
      tips: json['tips'],
    );
  }
}

class PrescriptionDetailsModel {
  final List<Medication> medications;

  PrescriptionDetailsModel({
    required this.medications,
  });

  factory PrescriptionDetailsModel.fromJson(List<dynamic> json) {
    List<Medication> medications =
        json.map((e) => Medication.fromJson(e)).toList();
    return PrescriptionDetailsModel(medications: medications);
  }
}
