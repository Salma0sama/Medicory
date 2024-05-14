import 'package:dio/dio.dart';
import 'package:medicory/models/get_clinic_model.dart';
import 'package:medicory/models/search_model.dart';

class SearchClinic {
  final Dio dio;

  SearchClinic(this.dio);

  Future<List<GetClinicSearch>> showByCode(String url) async {
    try {
      Response response = await dio.get(url);
      GetClinicSearch clinic = GetClinicSearch.fromJson(response.data);
      return [clinic];
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<List<GetClinicSearch>> showByEmail(String url) async {
    try {
      Response response = await dio.get(url);
      GetClinicSearch clinic = GetClinicSearch.fromJson(response.data);
      return [clinic];
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<List<GetClinicSearch>> showByName(String url) async {
    try {
      Response response = await dio.get(url);
      dynamic jsonData = response.data;
      if (jsonData is List) {
        return jsonData
            .map((ownerJson) => GetClinicSearch.fromJson(ownerJson))
            .toList();
      } else if (jsonData is Map) {
        GetClinicSearch owner = GetClinicSearch.fromJson(jsonData);
        return [owner];
      } else {
        return [];
      }
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<List<GetClinicModel>> showClinicById(String url) async {
    try {
      Response response = await dio.get(url);
      GetClinicModel clinic = GetClinicModel.fromJson(response.data);
      return [clinic];
    } catch (e) {
      print(e);
      return [];
    }
  }
}
