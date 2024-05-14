import 'package:dio/dio.dart';
import 'package:medicory/models/get_doctor_model.dart';
import 'package:medicory/models/search_model.dart';

class SearchDoctor {
  final Dio dio;

  SearchDoctor(this.dio);

  Future<List<GetDoctorSearch>> showByCode(String url) async {
    try {
      Response response = await dio.get(url);
      GetDoctorSearch doctor = GetDoctorSearch.fromJson(response.data);
      return [doctor];
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<List<GetDoctorSearch>> showByEmail(String url) async {
    try {
      Response response = await dio.get(url);
      GetDoctorSearch doctor = GetDoctorSearch.fromJson(response.data);
      return [doctor];
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<List<GetDoctorSearch>> showByName(String url) async {
    try {
      Response response = await dio.get(url);
      dynamic jsonData = response.data;
      if (jsonData is List) {
        return jsonData
            .map((ownerJson) => GetDoctorSearch.fromJson(ownerJson))
            .toList();
      } else if (jsonData is Map) {
        GetDoctorSearch owner = GetDoctorSearch.fromJson(jsonData);
        return [owner];
      } else {
        return [];
      }
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<List<GetDoctorModel>> showDoctorById(String url) async {
    try {
      Response response = await dio.get(url);
      GetDoctorModel doctor = GetDoctorModel.fromJson(response.data);
      return [doctor];
    } catch (e) {
      print(e);
      return [];
    }
  }
}
