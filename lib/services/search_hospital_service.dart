import 'package:dio/dio.dart';
import 'package:medicory/models/get_hospital_model.dart';
import 'package:medicory/models/search_model.dart';

class SearchHospital {
  final Dio dio;

  SearchHospital(this.dio);

  Future<List<GetHospitalSearch>> showByCode(String url) async {
    try {
      Response response = await dio.get(url);
      GetHospitalSearch hospital = GetHospitalSearch.fromJson(response.data);
      return [hospital];
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<List<GetHospitalSearch>> showByEmail(String url) async {
    try {
      Response response = await dio.get(url);
      GetHospitalSearch hospital = GetHospitalSearch.fromJson(response.data);
      return [hospital];
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<List<GetHospitalSearch>> showByName(String url) async {
    try {
      Response response = await dio.get(url);
      dynamic jsonData = response.data;
      if (jsonData is List) {
        return jsonData
            .map((ownerJson) => GetHospitalSearch.fromJson(ownerJson))
            .toList();
      } else if (jsonData is Map) {
        GetHospitalSearch owner = GetHospitalSearch.fromJson(jsonData);
        return [owner];
      } else {
        return [];
      }
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<List<GetHospitalModel>> showHospitalById(String url) async {
    try {
      Response response = await dio.get(url);
      GetHospitalModel hospital = GetHospitalModel.fromJson(response.data);
      return [hospital];
    } catch (e) {
      print(e);
      return [];
    }
  }
}
