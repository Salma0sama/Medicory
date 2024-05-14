import 'package:dio/dio.dart';
import 'package:medicory/models/get_lab_model.dart';
import 'package:medicory/models/search_model.dart';

class SearchLab {
  final Dio dio;

  SearchLab(this.dio);

  Future<List<GetLabSearch>> showByCode(String url) async {
    try {
      Response response = await dio.get(url);
      GetLabSearch lab = GetLabSearch.fromJson(response.data);
      return [lab];
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<List<GetLabSearch>> showByEmail(String url) async {
    try {
      Response response = await dio.get(url);
      GetLabSearch lab = GetLabSearch.fromJson(response.data);
      return [lab];
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<List<GetLabSearch>> showByName(String url) async {
    try {
      Response response = await dio.get(url);
      dynamic jsonData = response.data;
      if (jsonData is List) {
        return jsonData
            .map((ownerJson) => GetLabSearch.fromJson(ownerJson))
            .toList();
      } else if (jsonData is Map) {
        GetLabSearch owner = GetLabSearch.fromJson(jsonData);
        return [owner];
      } else {
        return [];
      }
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<List<GetLabModel>> showLabById(String url) async {
    try {
      Response response = await dio.get(url);
      GetLabModel lab = GetLabModel.fromJson(response.data);
      return [lab];
    } catch (e) {
      print(e);
      return [];
    }
  }
}
