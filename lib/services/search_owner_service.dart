import 'package:dio/dio.dart';
import 'package:medicory/models/get_owner_model.dart';
import 'package:medicory/models/search_model.dart';

class SearchOwner {
  final Dio dio;

  SearchOwner(this.dio);

  Future<List<GetOwnerSearch>> showByCode(String url) async {
    try {
      Response response = await dio.get(url);
      GetOwnerSearch owner = GetOwnerSearch.fromJson(response.data);
      return [owner];
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<List<GetOwnerSearch>> showByEmail(String url) async {
    try {
      Response response = await dio.get(url);
      GetOwnerSearch owner = GetOwnerSearch.fromJson(response.data);
      return [owner];
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<List<GetOwnerSearch>> showByName(String url) async {
    try {
      Response response = await dio.get(url);
      dynamic jsonData = response.data;
      if (jsonData is List) {
        return jsonData
            .map((ownerJson) => GetOwnerSearch.fromJson(ownerJson))
            .toList();
      } else if (jsonData is Map) {
        GetOwnerSearch owner = GetOwnerSearch.fromJson(jsonData);
        return [owner];
      } else {
        return [];
      }
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<List<GetOwnerModel>> showOwnerById(String url) async {
    try {
      Response response = await dio.get(url);
      GetOwnerModel owner = GetOwnerModel.fromJson(response.data);
      return [owner];
    } catch (e) {
      print(e);
      return [];
    }
  }
}
