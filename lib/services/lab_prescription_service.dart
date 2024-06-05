import 'package:dio/dio.dart';
import 'package:medicory/models/prescription_model.dart';

class LabPrescriptions {
  final Dio dio;

  LabPrescriptions(this.dio);

  Future<List<GetPrescriptionModel>> getLabPrescriptions(String url) async {
    try {
      Response response = await dio.get(url);
      List<dynamic> data = response.data as List<dynamic>;
      List<GetPrescriptionModel> prescriptions = data.map((json) {
        return GetPrescriptionModel.fromJson(json as Map<String, dynamic>);
      }).toList();
      return prescriptions;
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<List<GetPrescriptionDetailsModel>> getLabPrescriptionDetails(
      String url) async {
    try {
      Response response = await dio.get(url);
      List<dynamic> data = response.data as List<dynamic>;
      List<GetPrescriptionDetailsModel> prescriptions = data.map((json) {
        return GetPrescriptionDetailsModel.fromJson(
            json as Map<String, dynamic>);
      }).toList();
      return prescriptions;
    } catch (e) {
      print(e);
      return [];
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
}
