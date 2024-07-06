class GetPrescriptionModel {
  final int prescriptionId;
  final String? doctorName;
  final DateTime createdAt;

  GetPrescriptionModel({
    required this.prescriptionId,
    this.doctorName,
    required this.createdAt,
  });

  factory GetPrescriptionModel.fromJson(Map<String, dynamic> json) {
    return GetPrescriptionModel(
      prescriptionId: json['prescriptionId'] as int,
      doctorName: json['doctorName'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}

class GetLabTestsModel {
  int id;
  String name;
  String description;
  String testNotes;
  String? testResult;
  bool status;

  GetLabTestsModel(
      {required this.id,
      required this.name,
      required this.description,
      required this.testNotes,
      this.testResult,
      required this.status});

  factory GetLabTestsModel.fromJson(Map<String, dynamic> json) {
    return GetLabTestsModel(
      id: json['id'] as int,
      name: json['name'] as String,
      description: json['description'] as String,
      testNotes: json['testNotes'] as String,
      testResult: json['testResult'] as String?,
      status: json['status'] as bool,
    );
  }
}

class GetLabScanModel {
  int id;
  String name;
  String description;
  String resultNotes;
  String? imageResult;
  bool status;

  GetLabScanModel(
      {required this.id,
      required this.name,
      required this.description,
      required this.resultNotes,
      this.imageResult,
      required this.status});

  factory GetLabScanModel.fromJson(Map<String, dynamic> json) {
    return GetLabScanModel(
      id: json['id'] as int,
      name: json['name'] as String,
      description: json['description'] as String,
      resultNotes: json['resultNotes'] as String,
      imageResult: json['imageResult'] as String?,
      status: json['status'] as bool,
    );
  }
}
