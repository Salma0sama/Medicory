class GetPrescriptionModel {
  final int prescriptionId;
  final DateTime createdAt;

  GetPrescriptionModel({
    required this.prescriptionId,
    required this.createdAt,
  });

  factory GetPrescriptionModel.fromJson(Map<String, dynamic> json) {
    return GetPrescriptionModel(
      prescriptionId: json['prescriptionResponse']['prescriptionId'],
      createdAt: DateTime.parse(json['prescriptionResponse']['createdAt']),
    );
  }
}

class GetPrescriptionDetailsModel {
  final String? doctorName;
  final DateTime createdAt;

  GetPrescriptionDetailsModel({
    this.doctorName,
    required this.createdAt,
  });

  factory GetPrescriptionDetailsModel.fromJson(Map<String, dynamic> json) {
    return GetPrescriptionDetailsModel(
      doctorName: json['prescriptionResponse']['doctorName'],
      createdAt: DateTime.parse(json['prescriptionResponse']['createdAt']),
    );
  }
}

class GetLabTestsModel {
  int id;
  String name;
  String description;
  String testNotes;
  // String imageResult;
  bool status;

  GetLabTestsModel({
    required this.id,
    required this.name,
    required this.description,
    required this.testNotes,
    // required this.imageResult,
    required this.status,
  });

  factory GetLabTestsModel.fromJson(Map<String, dynamic> json) {
    return GetLabTestsModel(
      id: json['id'] as int,
      name: json['name'] as String,
      description: json['description'] as String,
      testNotes: json['testNotes'] as String,
      // imageResult: json['imageResult'] as String,
      status: json['status'] as bool,
    );
  }
}


// class PrescriptionResponse {
//   final int prescriptionId;
//   final String? doctorName;
//   final bool medicationStatus;
//   final bool prescriptionStatus;
//   final DateTime createdAt;
//   final List<Medication> medications;
//   final List<LabTest> labTests;
//   final List<ImagingTest> imagingTests;

//   PrescriptionResponse({
//     required this.prescriptionId,
//     this.doctorName,
//     required this.medicationStatus,
//     required this.prescriptionStatus,
//     required this.createdAt,
//     required this.medications,
//     required this.labTests,
//     required this.imagingTests,
//   });

//   factory PrescriptionResponse.fromJson(Map<String, dynamic> json) {
//     return PrescriptionResponse(
//       prescriptionId: json['prescriptionResponse']['prescriptionId'],
//       doctorName: json['prescriptionResponse']['doctorName'],
//       medicationStatus: json['prescriptionResponse']['medicationStatus'],
//       prescriptionStatus: json['prescriptionResponse']['prescriptionStatus'],
//       createdAt: DateTime.parse(json['prescriptionResponse']['createdAt']),
//       medications: (json['medications'] as List)
//           .map((e) => Medication.fromJson(e))
//           .toList(),
//       labTests:
//           (json['labTests'] as List).map((e) => LabTest.fromJson(e)).toList(),
//       imagingTests: (json['imagingTests'] as List)
//           .map((e) => ImagingTest.fromJson(e))
//           .toList(),
//     );
//   }
// }

// class Medication {
//   final int id;
//   final String dose;
//   final int frequency;
//   final String tips;

//   Medication({
//     required this.id,
//     required this.dose,
//     required this.frequency,
//     required this.tips,
//   });

//   factory Medication.fromJson(Map<String, dynamic> json) {
//     return Medication(
//       id: json['id'],
//       dose: json['dose'],
//       frequency: json['frequency'],
//       tips: json['tips'],
//     );
//   }
// }

// class LabTest {
//   final int id;
//   final String name;
//   final String description;
//   final String testNotes;
//   final String imageResult;
//   final bool status;

//   LabTest({
//     required this.id,
//     required this.name,
//     required this.description,
//     required this.testNotes,
//     required this.imageResult,
//     required this.status,
//   });

//   factory LabTest.fromJson(Map<String, dynamic> json) {
//     return LabTest(
//       id: json['id'],
//       name: json['name'],
//       description: json['description'],
//       testNotes: json['testNotes'],
//       imageResult: json['imageResult'],
//       status: json['status'],
//     );
//   }
// }

// class ImagingTest {
//   final int id;
//   final String name;
//   final String description;
//   final String imageResult;
//   final String resultNotes;
//   final bool status;

//   ImagingTest({
//     required this.id,
//     required this.name,
//     required this.description,
//     required this.imageResult,
//     required this.resultNotes,
//     required this.status,
//   });

//   factory ImagingTest.fromJson(Map<String, dynamic> json) {
//     return ImagingTest(
//       id: json['id'],
//       name: json['name'],
//       description: json['description'],
//       imageResult: json['imageResult'],
//       resultNotes: json['resultNotes'],
//       status: json['status'],
//     );
//   }
// }
