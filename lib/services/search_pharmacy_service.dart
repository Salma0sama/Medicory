import 'package:dio/dio.dart';
import 'package:medicory/models/get_pharmacy_model.dart';
import 'package:medicory/models/search_model.dart';

class SearchPharmacy {
  final Dio dio;

  SearchPharmacy(this.dio);

  Future<List<GetPharmacySearch>> showByCode(String url) async {
    try {
      Response response = await dio.get(url);
      GetPharmacySearch pharmacy = GetPharmacySearch.fromJson(response.data);
      return [pharmacy];
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<List<GetPharmacySearch>> showByEmail(String url) async {
    try {
      Response response = await dio.get(url);
      GetPharmacySearch pharmacy = GetPharmacySearch.fromJson(response.data);
      return [pharmacy];
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<List<GetPharmacySearch>> showByName(String url) async {
    try {
      Response response = await dio.get(url);
      dynamic jsonData = response.data;
      if (jsonData is List) {
        return jsonData
            .map((ownerJson) => GetPharmacySearch.fromJson(ownerJson))
            .toList();
      } else if (jsonData is Map) {
        GetPharmacySearch owner = GetPharmacySearch.fromJson(jsonData);
        return [owner];
      } else {
        return [];
      }
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<List<GetPharmacyModel>> showPharmacyById(String url) async {
    try {
      Response response = await dio.get(url);
      GetPharmacyModel pharmacy = GetPharmacyModel.fromJson(response.data);
      return [pharmacy];
    } catch (e) {
      print(e);
      return [];
    }
  }
}
