import 'package:dio/dio.dart';
import 'package:medicory/models/medication_model.dart';
import 'package:medicory/models/prescription_model.dart';

class Prescriptions {
  final Dio dio;

  Prescriptions(this.dio);

  Future<List<GetPrescriptionModel>> getPrescriptions(String url) async {
    try {
      Response response = await dio.get(url);
      if (response.statusCode == 200) {
        List<dynamic> data = response.data as List<dynamic>;
        List<GetPrescriptionModel> prescriptions = data.map((json) {
          return GetPrescriptionModel.fromJson(json as Map<String, dynamic>);
        }).toList();
        return prescriptions;
      } else {
        throw Exception('Failed to load prescriptions');
      }
    } catch (e) {
      print("Error fetching prescriptions: $e");
      return []; // Return empty list in case of error
    }
  }

  Future<List<GetLabTestsModel>> getLabTests(String url) async {
    try {
      Response response = await dio.get(url);
      List<dynamic> data = response.data as List<dynamic>;
      List<GetLabTestsModel> labTests = data.map((json) {
        return GetLabTestsModel.fromJson(json as Map<String, dynamic>);
      }).toList();
      return labTests;
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<List<GetLabScanModel>> getLabScans(String url) async {
    try {
      Response response = await dio.get(url);
      List<dynamic> data = response.data as List<dynamic>;
      List<GetLabScanModel> labScans = data.map((json) {
        return GetLabScanModel.fromJson(json as Map<String, dynamic>);
      }).toList();
      return labScans;
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<List<PrescriptionDetailsModel>> getPrescriptionDetails(
      String url) async {
    try {
      final response = await dio.get(url);
      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        List<PrescriptionDetailsModel> prescriptionDetails = [
          PrescriptionDetailsModel.fromJson(data)
        ];
        return prescriptionDetails;
      } else {
        throw Exception('Failed to load prescription details');
      }
    } catch (e) {
      throw Exception('Failed to load prescription details: $e');
    }
  }

  Future<Medication> getMedicationDetails(String url) async {
    try {
      print(
          "Fetching medication details from: $url"); // Add this line for debugging
      Response response = await dio.get(url);
      if (response.statusCode == 200) {
        return Medication.fromJson(response.data as Map<String, dynamic>);
      } else {
        throw Exception(
            'Failed to load medication details. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print("Error fetching medication details: $e");
      throw e; // Re-throw the error to handle it in the UI
    }
  }
}
