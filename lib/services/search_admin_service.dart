import 'package:dio/dio.dart';
import 'package:medicory/models/get_admin_model.dart';
import 'package:medicory/models/search_model.dart';

class SearchAdmin {
  final Dio dio;

  SearchAdmin(this.dio);

  Future<List<GetAdminSearch>> showByCode(String url) async {
    try {
      Response response = await dio.get(url);
      GetAdminSearch admin = GetAdminSearch.fromJson(response.data);
      return [admin];
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<List<GetAdminSearch>> showByEmail(String url) async {
    try {
      Response response = await dio.get(url);
      GetAdminSearch admin = GetAdminSearch.fromJson(response.data);
      return [admin];
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<List<GetAdminSearch>> showByName(String url) async {
    try {
      Response response = await dio.get(url);
      dynamic jsonData = response.data;
      if (jsonData is List) {
        return jsonData
            .map((ownerJson) => GetAdminSearch.fromJson(ownerJson))
            .toList();
      } else if (jsonData is Map) {
        GetAdminSearch owner = GetAdminSearch.fromJson(jsonData);
        return [owner];
      } else {
        return [];
      }
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<List<GetAdminModel>> showAdminById(String url) async {
    try {
      Response response = await dio.get(url);
      GetAdminModel admin = GetAdminModel.fromJson(response.data);
      return [admin];
    } catch (e) {
      print(e);
      return [];
    }
  }
}
